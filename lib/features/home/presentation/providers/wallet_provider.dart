import 'package:flutter_riverpod/flutter_riverpod.dart';

class WalletState {
  final double balance;
  final bool isWithdrawing;
  final String? lastWithdrawalStatus;

  const WalletState({
    this.balance = 0.0,
    this.isWithdrawing = false,
    this.lastWithdrawalStatus,
  });

  WalletState copyWith({
    double? balance,
    bool? isWithdrawing,
    String? lastWithdrawalStatus,
  }) {
    return WalletState(
      balance: balance ?? this.balance,
      isWithdrawing: isWithdrawing ?? this.isWithdrawing,
      lastWithdrawalStatus: lastWithdrawalStatus ?? this.lastWithdrawalStatus,
    );
  }
}

class WalletNotifier extends Notifier<WalletState> {
  @override
  WalletState build() {
    // Initial fetch simulation
    _fetchBalance();
    return const WalletState();
  }

  Future<void> _fetchBalance() async {
    // Simulate API fetch delay
    await Future.delayed(const Duration(milliseconds: 500));
    // Set to 0.0 until real API integration is available
    state = state.copyWith(balance: 0.0);
  }

  Future<void> withdraw(double amount) async {
    state = state.copyWith(isWithdrawing: true);
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    state = state.copyWith(
      isWithdrawing: false,
      lastWithdrawalStatus: 'Saldo sedang diproses untuk ditarik',
    );
  }

  void clearStatus() {
    state = state.copyWith(lastWithdrawalStatus: null);
  }
}

final walletProvider = NotifierProvider<WalletNotifier, WalletState>(() {
  return WalletNotifier();
});
