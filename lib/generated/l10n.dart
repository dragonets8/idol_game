// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `XWG Wallet`
  String get appName {
    return Intl.message(
      'XWG Wallet',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Previous`
  String get previous {
    return Intl.message(
      'Previous',
      name: 'previous',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Copy`
  String get copy {
    return Intl.message(
      'Copy',
      name: 'copy',
      desc: '',
      args: [],
    );
  }

  /// `Copy successfully`
  String get copy_success {
    return Intl.message(
      'Copy successfully',
      name: 'copy_success',
      desc: '',
      args: [],
    );
  }

  /// `Successfully`
  String get successfully {
    return Intl.message(
      'Successfully',
      name: 'successfully',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message(
      'Share',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get reset {
    return Intl.message(
      'Reset',
      name: 'reset',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message(
      'Update',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `Acknowledged`
  String get i_know {
    return Intl.message(
      'Acknowledged',
      name: 'i_know',
      desc: '',
      args: [],
    );
  }

  /// `Loading`
  String get loading {
    return Intl.message(
      'Loading',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `Click again to close the app`
  String get close_tips {
    return Intl.message(
      'Click again to close the app',
      name: 'close_tips',
      desc: '',
      args: [],
    );
  }

  /// `Add Wallet`
  String get start_wallet {
    return Intl.message(
      'Add Wallet',
      name: 'start_wallet',
      desc: '',
      args: [],
    );
  }

  /// `Create Wallet`
  String get create_wallet {
    return Intl.message(
      'Create Wallet',
      name: 'create_wallet',
      desc: '',
      args: [],
    );
  }

  /// `Wallet Name`
  String get wallet_name {
    return Intl.message(
      'Wallet Name',
      name: 'wallet_name',
      desc: '',
      args: [],
    );
  }

  /// `Wallet Address`
  String get wallet_address {
    return Intl.message(
      'Wallet Address',
      name: 'wallet_address',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your wallet name`
  String get wallet_name_tips {
    return Intl.message(
      'Please enter your wallet name',
      name: 'wallet_name_tips',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get guide_name {
    return Intl.message(
      'Name',
      name: 'guide_name',
      desc: '',
      args: [],
    );
  }

  /// `Generate Recovery Phrase`
  String get generate_mnemonic {
    return Intl.message(
      'Generate Recovery Phrase',
      name: 'generate_mnemonic',
      desc: '',
      args: [],
    );
  }

  /// `Recovery Phrase`
  String get guide_mnemonic {
    return Intl.message(
      'Recovery Phrase',
      name: 'guide_mnemonic',
      desc: '',
      args: [],
    );
  }

  /// `Backup Confirmed`
  String get backuped {
    return Intl.message(
      'Backup Confirmed',
      name: 'backuped',
      desc: '',
      args: [],
    );
  }

  /// `Verify`
  String get guide_verify {
    return Intl.message(
      'Verify',
      name: 'guide_verify',
      desc: '',
      args: [],
    );
  }

  /// `Verify Recovery Phrase`
  String get verify_mnemonic {
    return Intl.message(
      'Verify Recovery Phrase',
      name: 'verify_mnemonic',
      desc: '',
      args: [],
    );
  }

  /// `Wrong order of recovery phrase`
  String get mnemonic_wrong_order {
    return Intl.message(
      'Wrong order of recovery phrase',
      name: 'mnemonic_wrong_order',
      desc: '',
      args: [],
    );
  }

  /// `Payment Password`
  String get guide_password {
    return Intl.message(
      'Payment Password',
      name: 'guide_password',
      desc: '',
      args: [],
    );
  }

  /// `Please enter payment password`
  String get password_tips {
    return Intl.message(
      'Please enter payment password',
      name: 'password_tips',
      desc: '',
      args: [],
    );
  }

  /// `Please enter payment password again`
  String get repassword_tips {
    return Intl.message(
      'Please enter payment password again',
      name: 'repassword_tips',
      desc: '',
      args: [],
    );
  }

  /// `Register/Login`
  String get regist_login_title {
    return Intl.message(
      'Register/Login',
      name: 'regist_login_title',
      desc: '',
      args: [],
    );
  }

  /// `Create/Login wallet quickly`
  String get regist_login_tips {
    return Intl.message(
      'Create/Login wallet quickly',
      name: 'regist_login_tips',
      desc: '',
      args: [],
    );
  }

  /// `Via Mobile`
  String get via_mobile {
    return Intl.message(
      'Via Mobile',
      name: 'via_mobile',
      desc: '',
      args: [],
    );
  }

  /// `Via Email`
  String get via_email {
    return Intl.message(
      'Via Email',
      name: 'via_email',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login_title {
    return Intl.message(
      'Login',
      name: 'login_title',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register_title {
    return Intl.message(
      'Register',
      name: 'register_title',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout_title {
    return Intl.message(
      'Logout',
      name: 'logout_title',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phone_title {
    return Intl.message(
      'Phone Number',
      name: 'phone_title',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email_title {
    return Intl.message(
      'Email',
      name: 'email_title',
      desc: '',
      args: [],
    );
  }

  /// `Code`
  String get code_title {
    return Intl.message(
      'Code',
      name: 'code_title',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password_title {
    return Intl.message(
      'Password',
      name: 'password_title',
      desc: '',
      args: [],
    );
  }

  /// `Repeat Password`
  String get repassword_title {
    return Intl.message(
      'Repeat Password',
      name: 'repassword_title',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your phone`
  String get phone_placeholder {
    return Intl.message(
      'Please enter your phone',
      name: 'phone_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email`
  String get email_placeholder {
    return Intl.message(
      'Please enter your email',
      name: 'email_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your code`
  String get code_placeholder {
    return Intl.message(
      'Please enter your code',
      name: 'code_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your password`
  String get password_placeholder {
    return Intl.message(
      'Please enter your password',
      name: 'password_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your password again`
  String get repassword_placeholder {
    return Intl.message(
      'Please enter your password again',
      name: 'repassword_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Send Code`
  String get send_code {
    return Intl.message(
      'Send Code',
      name: 'send_code',
      desc: '',
      args: [],
    );
  }

  /// `Resend Code`
  String get resend_code {
    return Intl.message(
      'Resend Code',
      name: 'resend_code',
      desc: '',
      args: [],
    );
  }

  /// `Forget Password ?`
  String get forget_password {
    return Intl.message(
      'Forget Password ?',
      name: 'forget_password',
      desc: '',
      args: [],
    );
  }

  /// `Reset login password`
  String get reset_login_password {
    return Intl.message(
      'Reset login password',
      name: 'reset_login_password',
      desc: '',
      args: [],
    );
  }

  /// `Change login password`
  String get change_login_password {
    return Intl.message(
      'Change login password',
      name: 'change_login_password',
      desc: '',
      args: [],
    );
  }

  /// `Old Password`
  String get old_password_title {
    return Intl.message(
      'Old Password',
      name: 'old_password_title',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your old password`
  String get old_password_placeholder {
    return Intl.message(
      'Please enter your old password',
      name: 'old_password_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get new_password_title {
    return Intl.message(
      'New Password',
      name: 'new_password_title',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your new password`
  String get new_password_placeholder {
    return Intl.message(
      'Please enter your new password',
      name: 'new_password_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Select Country`
  String get select_country_title {
    return Intl.message(
      'Select Country',
      name: 'select_country_title',
      desc: '',
      args: [],
    );
  }

  /// `Country name or code`
  String get search_country_placeholder {
    return Intl.message(
      'Country name or code',
      name: 'search_country_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `I have read the `
  String get policy_service_title1 {
    return Intl.message(
      'I have read the ',
      name: 'policy_service_title1',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get policy_service_title2 {
    return Intl.message(
      'Privacy Policy',
      name: 'policy_service_title2',
      desc: '',
      args: [],
    );
  }

  /// ` and `
  String get policy_service_title3 {
    return Intl.message(
      ' and ',
      name: 'policy_service_title3',
      desc: '',
      args: [],
    );
  }

  /// `Teams of Service`
  String get policy_service_title4 {
    return Intl.message(
      'Teams of Service',
      name: 'policy_service_title4',
      desc: '',
      args: [],
    );
  }

  /// ` in detail`
  String get policy_service_title5 {
    return Intl.message(
      ' in detail',
      name: 'policy_service_title5',
      desc: '',
      args: [],
    );
  }

  /// `Create a new wallet`
  String get create_wallet_tips {
    return Intl.message(
      'Create a new wallet',
      name: 'create_wallet_tips',
      desc: '',
      args: [],
    );
  }

  /// `From recovery phrase or private key`
  String get import_wallet_tips {
    return Intl.message(
      'From recovery phrase or private key',
      name: 'import_wallet_tips',
      desc: '',
      args: [],
    );
  }

  /// `Regenerate`
  String get regenerate_mnemonic {
    return Intl.message(
      'Regenerate',
      name: 'regenerate_mnemonic',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the recovery phrase, split by space`
  String get import_mnemonic_placeholder {
    return Intl.message(
      'Please enter the recovery phrase, split by space',
      name: 'import_mnemonic_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the private key`
  String get import_privatekey_placeholder {
    return Intl.message(
      'Please enter the private key',
      name: 'import_privatekey_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Import Wallet`
  String get import_wallet {
    return Intl.message(
      'Import Wallet',
      name: 'import_wallet',
      desc: '',
      args: [],
    );
  }

  /// `By Recovery Phrase`
  String get mnemonic_import {
    return Intl.message(
      'By Recovery Phrase',
      name: 'mnemonic_import',
      desc: '',
      args: [],
    );
  }

  /// `By Private Key`
  String get privatekey_import {
    return Intl.message(
      'By Private Key',
      name: 'privatekey_import',
      desc: '',
      args: [],
    );
  }

  /// `Your 12-words Recovery Phrase`
  String get mnemonic_import_tips {
    return Intl.message(
      'Your 12-words Recovery Phrase',
      name: 'mnemonic_import_tips',
      desc: '',
      args: [],
    );
  }

  /// `Your Private Key`
  String get privatekey_import_tips {
    return Intl.message(
      'Your Private Key',
      name: 'privatekey_import_tips',
      desc: '',
      args: [],
    );
  }

  /// `Wallet already exists`
  String get wallet_already_exist {
    return Intl.message(
      'Wallet already exists',
      name: 'wallet_already_exist',
      desc: '',
      args: [],
    );
  }

  /// `Wallet`
  String get wallet {
    return Intl.message(
      'Wallet',
      name: 'wallet',
      desc: '',
      args: [],
    );
  }

  /// `My Wallet`
  String get wallet_list {
    return Intl.message(
      'My Wallet',
      name: 'wallet_list',
      desc: '',
      args: [],
    );
  }

  /// `Scan`
  String get wallet_scan {
    return Intl.message(
      'Scan',
      name: 'wallet_scan',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get wallet_send {
    return Intl.message(
      'Send',
      name: 'wallet_send',
      desc: '',
      args: [],
    );
  }

  /// `Receive`
  String get wallet_receive {
    return Intl.message(
      'Receive',
      name: 'wallet_receive',
      desc: '',
      args: [],
    );
  }

  /// `Message`
  String get wallet_message {
    return Intl.message(
      'Message',
      name: 'wallet_message',
      desc: '',
      args: [],
    );
  }

  /// `Assets`
  String get wallet_assets {
    return Intl.message(
      'Assets',
      name: 'wallet_assets',
      desc: '',
      args: [],
    );
  }

  /// `All Assets`
  String get wallet_assets_all {
    return Intl.message(
      'All Assets',
      name: 'wallet_assets_all',
      desc: '',
      args: [],
    );
  }

  /// `Assets Filter`
  String get wallet_assets_filter {
    return Intl.message(
      'Assets Filter',
      name: 'wallet_assets_filter',
      desc: '',
      args: [],
    );
  }

  /// `Browse`
  String get wallet_browse {
    return Intl.message(
      'Browse',
      name: 'wallet_browse',
      desc: '',
      args: [],
    );
  }

  /// `Transaction`
  String get wallet_transaction {
    return Intl.message(
      'Transaction',
      name: 'wallet_transaction',
      desc: '',
      args: [],
    );
  }

  /// `Add Token`
  String get token_add {
    return Intl.message(
      'Add Token',
      name: 'token_add',
      desc: '',
      args: [],
    );
  }

  /// `Select Token`
  String get token_select {
    return Intl.message(
      'Select Token',
      name: 'token_select',
      desc: '',
      args: [],
    );
  }

  /// `Enter the token name`
  String get token_select_place {
    return Intl.message(
      'Enter the token name',
      name: 'token_select_place',
      desc: '',
      args: [],
    );
  }

  /// `Scanning QR code for payment`
  String get token_receive_tips {
    return Intl.message(
      'Scanning QR code for payment',
      name: 'token_receive_tips',
      desc: '',
      args: [],
    );
  }

  /// `Receive Address`
  String get receive_address {
    return Intl.message(
      'Receive Address',
      name: 'receive_address',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your receiving address`
  String get receive_address_placeholder {
    return Intl.message(
      'Please enter your receiving address',
      name: 'receive_address_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Transfer Amount`
  String get transfer_amount {
    return Intl.message(
      'Transfer Amount',
      name: 'transfer_amount',
      desc: '',
      args: [],
    );
  }

  /// `Available`
  String get transfer_available {
    return Intl.message(
      'Available',
      name: 'transfer_available',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the transfer amount`
  String get transfer_amount_placeholder {
    return Intl.message(
      'Please enter the transfer amount',
      name: 'transfer_amount_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `MAX`
  String get transfer_all {
    return Intl.message(
      'MAX',
      name: 'transfer_all',
      desc: '',
      args: [],
    );
  }

  /// `Contract Address`
  String get contract_address {
    return Intl.message(
      'Contract Address',
      name: 'contract_address',
      desc: '',
      args: [],
    );
  }

  /// `No data`
  String get transaction_no_data {
    return Intl.message(
      'No data',
      name: 'transaction_no_data',
      desc: '',
      args: [],
    );
  }

  /// `Processing`
  String get transaction_state_process {
    return Intl.message(
      'Processing',
      name: 'transaction_state_process',
      desc: '',
      args: [],
    );
  }

  /// `Succeeded`
  String get transaction_state_success {
    return Intl.message(
      'Succeeded',
      name: 'transaction_state_success',
      desc: '',
      args: [],
    );
  }

  /// `Failed`
  String get transaction_state_failed {
    return Intl.message(
      'Failed',
      name: 'transaction_state_failed',
      desc: '',
      args: [],
    );
  }

  /// `From`
  String get transaction_from {
    return Intl.message(
      'From',
      name: 'transaction_from',
      desc: '',
      args: [],
    );
  }

  /// `To`
  String get transaction_to {
    return Intl.message(
      'To',
      name: 'transaction_to',
      desc: '',
      args: [],
    );
  }

  /// `Gas Fee`
  String get transaction_gas {
    return Intl.message(
      'Gas Fee',
      name: 'transaction_gas',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get transaction_time {
    return Intl.message(
      'Time',
      name: 'transaction_time',
      desc: '',
      args: [],
    );
  }

  /// `Block Height`
  String get transaction_block_height {
    return Intl.message(
      'Block Height',
      name: 'transaction_block_height',
      desc: '',
      args: [],
    );
  }

  /// `Txid`
  String get transaction_hash {
    return Intl.message(
      'Txid',
      name: 'transaction_hash',
      desc: '',
      args: [],
    );
  }

  /// `Details in block broswer`
  String get transaction_broswer {
    return Intl.message(
      'Details in block broswer',
      name: 'transaction_broswer',
      desc: '',
      args: [],
    );
  }

  /// `NFT List`
  String get nft_list {
    return Intl.message(
      'NFT List',
      name: 'nft_list',
      desc: '',
      args: [],
    );
  }

  /// `Receive`
  String get nft_receive {
    return Intl.message(
      'Receive',
      name: 'nft_receive',
      desc: '',
      args: [],
    );
  }

  /// `Transfer`
  String get nft_transfer {
    return Intl.message(
      'Transfer',
      name: 'nft_transfer',
      desc: '',
      args: [],
    );
  }

  /// `Transfer NFT`
  String get nft_receive_address {
    return Intl.message(
      'Transfer NFT',
      name: 'nft_receive_address',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the NFT receiving address`
  String get nft_receive_address_tips {
    return Intl.message(
      'Please enter the NFT receiving address',
      name: 'nft_receive_address_tips',
      desc: '',
      args: [],
    );
  }

  /// `NFT receiving address is not available`
  String get nft_receive_address_wrong {
    return Intl.message(
      'NFT receiving address is not available',
      name: 'nft_receive_address_wrong',
      desc: '',
      args: [],
    );
  }

  /// `Top`
  String get dapp_recommend {
    return Intl.message(
      'Top',
      name: 'dapp_recommend',
      desc: '',
      args: [],
    );
  }

  /// `My`
  String get dapp_my {
    return Intl.message(
      'My',
      name: 'dapp_my',
      desc: '',
      args: [],
    );
  }

  /// `Trending`
  String get dapp_hot {
    return Intl.message(
      'Trending',
      name: 'dapp_hot',
      desc: '',
      args: [],
    );
  }

  /// `New`
  String get dapp_new {
    return Intl.message(
      'New',
      name: 'dapp_new',
      desc: '',
      args: [],
    );
  }

  /// `Opening a Dapp`
  String get dapp_open {
    return Intl.message(
      'Opening a Dapp',
      name: 'dapp_open',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get dapp_name {
    return Intl.message(
      'Name',
      name: 'dapp_name',
      desc: '',
      args: [],
    );
  }

  /// `Info`
  String get dapp_introduce {
    return Intl.message(
      'Info',
      name: 'dapp_introduce',
      desc: '',
      args: [],
    );
  }

  /// `Website`
  String get dapp_link {
    return Intl.message(
      'Website',
      name: 'dapp_link',
      desc: '',
      args: [],
    );
  }

  /// `Risk Warning`
  String get dapp_warning {
    return Intl.message(
      'Risk Warning',
      name: 'dapp_warning',
      desc: '',
      args: [],
    );
  }

  /// `We'll not be responsible or liable to you for any asset losses in any behaviors related to any Dapps. We'll collaborate with the authority and provide relevant data for any necessary investigation.`
  String get dapp_warning_tips {
    return Intl.message(
      'We\'ll not be responsible or liable to you for any asset losses in any behaviors related to any Dapps. We\'ll collaborate with the authority and provide relevant data for any necessary investigation.',
      name: 'dapp_warning_tips',
      desc: '',
      args: [],
    );
  }

  /// `Copy URL`
  String get dapp_copy {
    return Intl.message(
      'Copy URL',
      name: 'dapp_copy',
      desc: '',
      args: [],
    );
  }

  /// `Switch Network`
  String get dapp_switch_chain {
    return Intl.message(
      'Switch Network',
      name: 'dapp_switch_chain',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get dapp_about {
    return Intl.message(
      'About',
      name: 'dapp_about',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get dapp_refresh {
    return Intl.message(
      'Refresh',
      name: 'dapp_refresh',
      desc: '',
      args: [],
    );
  }

  /// `Favorite`
  String get dapp_star {
    return Intl.message(
      'Favorite',
      name: 'dapp_star',
      desc: '',
      args: [],
    );
  }

  /// `Favorited`
  String get dapp_stared {
    return Intl.message(
      'Favorited',
      name: 'dapp_stared',
      desc: '',
      args: [],
    );
  }

  /// `Sign Message`
  String get sign_message {
    return Intl.message(
      'Sign Message',
      name: 'sign_message',
      desc: '',
      args: [],
    );
  }

  /// `Sign Transaction`
  String get sign_transaction {
    return Intl.message(
      'Sign Transaction',
      name: 'sign_transaction',
      desc: '',
      args: [],
    );
  }

  /// `Signature Content`
  String get sign_content {
    return Intl.message(
      'Signature Content',
      name: 'sign_content',
      desc: '',
      args: [],
    );
  }

  /// `Transaction Content`
  String get transaction_content {
    return Intl.message(
      'Transaction Content',
      name: 'transaction_content',
      desc: '',
      args: [],
    );
  }

  /// `My`
  String get my {
    return Intl.message(
      'My',
      name: 'my',
      desc: '',
      args: [],
    );
  }

  /// `Setting`
  String get my_setting {
    return Intl.message(
      'Setting',
      name: 'my_setting',
      desc: '',
      args: [],
    );
  }

  /// `Wallets`
  String get my_wallet {
    return Intl.message(
      'Wallets',
      name: 'my_wallet',
      desc: '',
      args: [],
    );
  }

  /// `Securtity`
  String get my_security {
    return Intl.message(
      'Securtity',
      name: 'my_security',
      desc: '',
      args: [],
    );
  }

  /// `About Us`
  String get my_about {
    return Intl.message(
      'About Us',
      name: 'my_about',
      desc: '',
      args: [],
    );
  }

  /// `Feedback`
  String get my_feedback {
    return Intl.message(
      'Feedback',
      name: 'my_feedback',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get setting_language {
    return Intl.message(
      'Language',
      name: 'setting_language',
      desc: '',
      args: [],
    );
  }

  /// `Currency`
  String get setting_currency {
    return Intl.message(
      'Currency',
      name: 'setting_currency',
      desc: '',
      args: [],
    );
  }

  /// `Dark Mode`
  String get setting_dark {
    return Intl.message(
      'Dark Mode',
      name: 'setting_dark',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get delete_user_title {
    return Intl.message(
      'Delete Account',
      name: 'delete_user_title',
      desc: '',
      args: [],
    );
  }

  /// `Verify payment password`
  String get verify_password {
    return Intl.message(
      'Verify payment password',
      name: 'verify_password',
      desc: '',
      args: [],
    );
  }

  /// `Verify login password`
  String get verify_login_password {
    return Intl.message(
      'Verify login password',
      name: 'verify_login_password',
      desc: '',
      args: [],
    );
  }

  /// `Set payment password`
  String get set_password {
    return Intl.message(
      'Set payment password',
      name: 'set_password',
      desc: '',
      args: [],
    );
  }

  /// `Please enter payment password`
  String get enter_password_tips {
    return Intl.message(
      'Please enter payment password',
      name: 'enter_password_tips',
      desc: '',
      args: [],
    );
  }

  /// `Please enter login password`
  String get enter_login_password_tips {
    return Intl.message(
      'Please enter login password',
      name: 'enter_login_password_tips',
      desc: '',
      args: [],
    );
  }

  /// `Please enter new payment password`
  String get new_password_tips {
    return Intl.message(
      'Please enter new payment password',
      name: 'new_password_tips',
      desc: '',
      args: [],
    );
  }

  /// `Please enter new payment password again`
  String get re_password_tips {
    return Intl.message(
      'Please enter new payment password again',
      name: 're_password_tips',
      desc: '',
      args: [],
    );
  }

  /// `Password verification failed`
  String get verify_password_failed {
    return Intl.message(
      'Password verification failed',
      name: 'verify_password_failed',
      desc: '',
      args: [],
    );
  }

  /// `The password must be 6-20 characters and contain uppercase and lowercase letters and numbers`
  String get password_format_tips {
    return Intl.message(
      'The password must be 6-20 characters and contain uppercase and lowercase letters and numbers',
      name: 'password_format_tips',
      desc: '',
      args: [],
    );
  }

  /// `The two passwords are inconsistent`
  String get inconsistent_password {
    return Intl.message(
      'The two passwords are inconsistent',
      name: 'inconsistent_password',
      desc: '',
      args: [],
    );
  }

  /// `Change Name`
  String get wallet_change_name {
    return Intl.message(
      'Change Name',
      name: 'wallet_change_name',
      desc: '',
      args: [],
    );
  }

  /// `Show Private Key`
  String get wallet_show_privatekey {
    return Intl.message(
      'Show Private Key',
      name: 'wallet_show_privatekey',
      desc: '',
      args: [],
    );
  }

  /// `Delete Wallet`
  String get wallet_delete {
    return Intl.message(
      'Delete Wallet',
      name: 'wallet_delete',
      desc: '',
      args: [],
    );
  }

  /// `Make sure you have backuped this wallet`
  String get wallet_delete_tips {
    return Intl.message(
      'Make sure you have backuped this wallet',
      name: 'wallet_delete_tips',
      desc: '',
      args: [],
    );
  }

  /// `Please enter new wallet name`
  String get wallet_name_placeholder {
    return Intl.message(
      'Please enter new wallet name',
      name: 'wallet_name_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Keep at least one wallet`
  String get keep_wallet_tips {
    return Intl.message(
      'Keep at least one wallet',
      name: 'keep_wallet_tips',
      desc: '',
      args: [],
    );
  }

  /// `Face ID`
  String get faceid {
    return Intl.message(
      'Face ID',
      name: 'faceid',
      desc: '',
      args: [],
    );
  }

  /// `Fingerprint`
  String get fingerprint {
    return Intl.message(
      'Fingerprint',
      name: 'fingerprint',
      desc: '',
      args: [],
    );
  }

  /// `App Locker`
  String get app_locker {
    return Intl.message(
      'App Locker',
      name: 'app_locker',
      desc: '',
      args: [],
    );
  }

  /// `Change payment password`
  String get change_passcode {
    return Intl.message(
      'Change payment password',
      name: 'change_passcode',
      desc: '',
      args: [],
    );
  }

  /// `Verify payment password`
  String get verify_passcode {
    return Intl.message(
      'Verify payment password',
      name: 'verify_passcode',
      desc: '',
      args: [],
    );
  }

  /// `Please set payment password`
  String get set_passcode {
    return Intl.message(
      'Please set payment password',
      name: 'set_passcode',
      desc: '',
      args: [],
    );
  }

  /// `Please enter payment password again`
  String get check_passcode {
    return Intl.message(
      'Please enter payment password again',
      name: 'check_passcode',
      desc: '',
      args: [],
    );
  }

  /// `Important Tips`
  String get important_tips {
    return Intl.message(
      'Important Tips',
      name: 'important_tips',
      desc: '',
      args: [],
    );
  }

  /// `1. Backup recovery phrase, use paper and pen to copy recovery phrase correctly. If your mobile phone is lost, stolen or damaged, recovery phrase can help restore your assets\n\n2. Offline storage, keep it in a safe place where the network is isolated\n\n3. Do not share or store recovery phrase in an online environment, such as email, photo albums, social applications, etc`
  String get mnemonic_tips_content {
    return Intl.message(
      '1. Backup recovery phrase, use paper and pen to copy recovery phrase correctly. If your mobile phone is lost, stolen or damaged, recovery phrase can help restore your assets\n\n2. Offline storage, keep it in a safe place where the network is isolated\n\n3. Do not share or store recovery phrase in an online environment, such as email, photo albums, social applications, etc',
      name: 'mnemonic_tips_content',
      desc: '',
      args: [],
    );
  }

  /// `The payment password cannot be reset and can only be modified. If you forget the payment password, please delete the wallet first, and then import phrase or private key to recover the wallet.`
  String get password_tips_content {
    return Intl.message(
      'The payment password cannot be reset and can only be modified. If you forget the payment password, please delete the wallet first, and then import phrase or private key to recover the wallet.',
      name: 'password_tips_content',
      desc: '',
      args: [],
    );
  }

  /// `Delete your account permanently?`
  String get delete_user_tips1 {
    return Intl.message(
      'Delete your account permanently?',
      name: 'delete_user_tips1',
      desc: '',
      args: [],
    );
  }

  /// `1. Your account will be permanently deleted\n\n2. If you want to use this account again after deleting it, please re-register\n\n3. After re-registering, a new wallet will be created, please make sure that you have properly backed up your current wallet's private key`
  String get delete_user_tips2 {
    return Intl.message(
      '1. Your account will be permanently deleted\n\n2. If you want to use this account again after deleting it, please re-register\n\n3. After re-registering, a new wallet will be created, please make sure that you have properly backed up your current wallet\'s private key',
      name: 'delete_user_tips2',
      desc: '',
      args: [],
    );
  }

  /// `Backup recovery phrase`
  String get create_wallet_tips_11 {
    return Intl.message(
      'Backup recovery phrase',
      name: 'create_wallet_tips_11',
      desc: '',
      args: [],
    );
  }

  /// `Use paper and pen to copy recovery phrase correctly`
  String get create_wallet_tips_12 {
    return Intl.message(
      'Use paper and pen to copy recovery phrase correctly',
      name: 'create_wallet_tips_12',
      desc: '',
      args: [],
    );
  }

  /// `If your mobile phone is lost, stolen or damaged, recovery phrase can help restore your assets`
  String get create_wallet_tips_13 {
    return Intl.message(
      'If your mobile phone is lost, stolen or damaged, recovery phrase can help restore your assets',
      name: 'create_wallet_tips_13',
      desc: '',
      args: [],
    );
  }

  /// `Offline storage`
  String get create_wallet_tips_21 {
    return Intl.message(
      'Offline storage',
      name: 'create_wallet_tips_21',
      desc: '',
      args: [],
    );
  }

  /// `Keep it in a safe place where the network is isolated`
  String get create_wallet_tips_22 {
    return Intl.message(
      'Keep it in a safe place where the network is isolated',
      name: 'create_wallet_tips_22',
      desc: '',
      args: [],
    );
  }

  /// `Do not share or store recovery phrase in an online environment, such as email, photo albums, social applications, etc`
  String get create_wallet_tips_23 {
    return Intl.message(
      'Do not share or store recovery phrase in an online environment, such as email, photo albums, social applications, etc',
      name: 'create_wallet_tips_23',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}