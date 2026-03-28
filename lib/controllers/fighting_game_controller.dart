import 'dart:async';
import 'package:fighting_game/enums/attack_type.dart';
import 'package:fighting_game/enums/fighter_id.dart';
import 'package:fighting_game/enums/move_direction.dart';
import 'package:fighting_game/game/combat_game.dart';
import 'package:fighting_game/models/player_command/player_command.dart';
import 'package:fighting_game/models/player_stats.dart';
import 'package:fighting_game/udp/udp_transport.dart';
import 'package:flame/components.dart';
import '../components/fighter_component.dart';

enum RoundState { countdown, fighting, roundOver, matchOver }

class FightingGameController extends Component
    with HasGameReference<CombatGame> {
  final FighterComponent player1;
  final FighterComponent player2;
  final UdpTransport transport;
  final String localPlayerId;
  final bool twoPlayer;

  // RoundState roundState = RoundState.countdown;
  RoundState roundState = RoundState.fighting;

  int player1Wins = 0;
  int player2Wins = 0;
  int _seq = 0;

  // Maps FighterId → FighterComponent for clean dispatch
  late final Map<FighterId, FighterComponent> _fighters;

  // The local player's FighterId (derived from localPlayerId)
  late final FighterId _localId;

  FightingGameController({
    required this.player1,
    required this.player2,
    required this.transport,
    required this.localPlayerId,
    this.twoPlayer = false,
  });

  @override
  FutureOr<void> onLoad() async {
    _fighters = {FighterId.player1: player1, FighterId.player2: player2};

    _localId = localPlayerId == 'player1'
        ? FighterId.player1
        : FighterId.player2;

    // All remote input arrives here — treated identically to local input
    if (twoPlayer) {
      transport.onStateReceived.listen(_onNetworkState);
    }
  }

  // ── Main entry point — called by HUD, network, or AI ─────────────

  /// Dispatch any command to the correct fighter.
  /// This is the ONLY way fighters receive instructions.
  void dispatch(PlayerCommand command) {
    if (roundState != RoundState.fighting) return;

    final fighter = _fighters[command.target];
    if (fighter == null) return;

    switch (command) {
      case MoveCommand(:final direction):
        fighter.applyMove(direction);

      case SprintCommand(:final active):
        fighter.applyPowerup();
      case JumpCommand():
        fighter.applyJump();

      case AttackCommand(:final type):
        fighter.applyAttack(type);
        // After applying attack locally, check if hitbox overlaps opponent
        _resolveAttackHit(attacker: fighter);

      case TakeDamageCommand(:final amount, :final source):
        // fighter.applyDamage(amount, source);
        _checkRoundEnd();
    }
  }

  // ── Called by CombatGame.update(dt) every frame ───────────────────
  @override
  void update(double dt) {
    if (roundState != RoundState.fighting) return;

    // Read local fighter's current input state and send to server
    // final local = _fighters[_localId]!;
    // if (twoPlayer) {
    //   transport.sendRawInput(
    //     playerId: localPlayerId,
    //     seq: ++_seq,
    //     move: local.move,
    //     sprint: local.onPowerup,
    //     jump: local.jumping,
    //     attack: _toAttackType(local.currentAttack),
    //   );
    // }
  }

  // ── Hit resolution ────────────────────────────────────────────────

  void _resolveAttackHit({required FighterComponent attacker}) {
    final defender = attacker.fighterId == FighterId.player1
        ? player2
        : player1;
    final defTarget = attacker.fighterId == FighterId.player1
        ? FighterId.player2
        : FighterId.player1;

    // Check if attacker's hitbox overlaps defender's healthHitbox
    // Flame collision system handles this via CollisionCallbacks,
    // but for authoritative damage we cross-check here using AABB
    final attackerBox = attacker.toAbsoluteRect();
    // final defenderBox = defender.healthHitbox.toAbsoluteRect();

    // if (attackerBox.overlaps(defenderBox)) {
    //   final damage = _damageFor(attacker.currentAttack, attacker.stats);
    //   dispatch(TakeDamageCommand(defTarget, damage, attacker.currentAttack));
    // }
  }

  double _damageFor(AttackType type, PlayerStats stats) {
    return switch (type) {
      AttackType.one => 5,
      AttackType.two => 5,
      AttackType.special => 5,
      AttackType.three => 5,
      AttackType.none => 0,
    };
  }

  void _checkRoundEnd() {
    if (player1.health <= 0) {
      player2Wins++;
      roundState = RoundState.roundOver;
    } else if (player2.health <= 0) {
      player1Wins++;
      roundState = RoundState.roundOver;
    }
  }

  // ── Network state handler ─────────────────────────────────────────

  /// Incoming packet from the opponent's device.
  /// Translated directly into PlayerCommands — same path as local HUD.
  void _onNetworkState(Map<String, dynamic> state) {
    final remoteId = _localId == FighterId.player1
        ? FighterId.player2
        : FighterId.player1;

    // Movement
    final moveX = state['mx'] as int? ?? 0;
    final moveY = state['mx'] as int? ?? 0;
    // dispatch(
    //   MoveCommand(remoteId, Vector2(moveX.toDouble(), moveY.toDouble())),
    // );

    if ((state['sp'] as int? ?? 0) == 1) {
      dispatch(SprintCommand(remoteId, true));
    } else {
      dispatch(SprintCommand(remoteId, false));
    }

    final attackIndex = state['at'] as int? ?? 0;
    if (attackIndex > 0) {
      dispatch(AttackCommand(remoteId, AttackType.values[attackIndex]));
    }

    // Reconcile positions from authoritative server state
    final players = state['players'] as Map<String, dynamic>?;
    if (players != null) {
      for (final entry in players.entries) {
        final fid = entry.key == 'player1'
            ? FighterId.player1
            : FighterId.player2;
        final data = entry.value as Map<String, dynamic>;
        _fighters[fid]?.applyServerReconcile(
          Vector2((data['x'] as num).toDouble(), (data['y'] as num).toDouble()),
          (data['hp'] as num).toDouble(),
        );
      }
    }
  }

  AttackType _toAttackType(AttackType a) =>
      a; // passthrough, can remap if needed
}
