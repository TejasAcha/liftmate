class SpinnerConfigModel {
  SpinnerConfig? data;

  SpinnerConfigModel({this.data});

  SpinnerConfigModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? SpinnerConfig.fromJson(json['data']) : null;
  }
}

class SpinnerConfig {
  List<RewardItem>? rewards;
  int? spinCount;
  int? spinsUsed;
  double? bonusMultiplier;

  SpinnerConfig({
    this.rewards,
    this.spinCount,
    this.spinsUsed,
    this.bonusMultiplier,
  });

  SpinnerConfig.fromJson(Map<String, dynamic> json) {
    if (json['rewards'] != null) {
      rewards = <RewardItem>[];
      json['rewards'].forEach((v) {
        rewards!.add(RewardItem.fromJson(v));
      });
    }
    spinCount = json['spin_count'];
    spinsUsed = json['spins_used'] ?? 0;
    bonusMultiplier = json['bonus_multiplier'] != null
        ? double.parse(json['bonus_multiplier'].toString())
        : 1.0;
  }

  int get spinsRemaining => (spinCount ?? 0) - (spinsUsed ?? 0);
  bool get canSpin => spinsRemaining > 0;
}

class RewardItem {
  String? id;
  String? title;
  String? description;
  double? amount;
  String? type; // 'wallet_credit', 'discount', 'points', etc.
  String? color; // Hex color for wheel segment
  int? probability;

  RewardItem({
    this.id,
    this.title,
    this.description,
    this.amount,
    this.type,
    this.color,
    this.probability,
  });

  RewardItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    amount = json['amount'] != null ? double.parse(json['amount'].toString()) : 0.0;
    type = json['type'];
    color = json['color'] ?? '#FF9800';
    probability = json['probability'] ?? 1;
  }
}

class SpinResultModel {
  SpinResult? data;

  SpinResultModel({this.data});

  SpinResultModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? SpinResult.fromJson(json['data']) : null;
  }
}

class SpinResult {
  String? id;
  RewardItem? reward;
  double? walletCreditAmount;
  String? status;
  String? message;
  double? newWalletBalance;
  String? rewardAppliedAt;

  SpinResult({
    this.id,
    this.reward,
    this.walletCreditAmount,
    this.status,
    this.message,
    this.newWalletBalance,
    this.rewardAppliedAt,
  });

  SpinResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reward = json['reward'] != null ? RewardItem.fromJson(json['reward']) : null;
    walletCreditAmount = json['wallet_credit_amount'] != null
        ? double.parse(json['wallet_credit_amount'].toString())
        : 0.0;
    status = json['status'];
    message = json['message'];
    newWalletBalance = json['new_wallet_balance'] != null
        ? double.parse(json['new_wallet_balance'].toString())
        : 0.0;
    rewardAppliedAt = json['reward_applied_at'];
  }
}
