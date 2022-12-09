import 'package:flutter/material.dart';
import 'colors.dart';
import 'dimens.dart';

class TextStyles {
  // NaviBar
  static const TextStyle naviTitle = const TextStyle(
    color: Colors.white,
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle navi_item = const TextStyle(
    color: Colours.app_main,
    fontSize: Dimens.font_sp14,
    fontWeight: FontWeight.w500,
  );

  // Wallet: guide
  static const TextStyle wallet_guide_title = const TextStyle(
    fontSize: 13,
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle wallet_guide_desc = const TextStyle(
    color: Colours.text_light,
    fontSize: 11,
  );
  static const TextStyle wallet_guide_bold24 = const TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle wallet_guide_button = const TextStyle(
    color: Colors.white,
    fontSize: 13,
  );
  static const TextStyle wallet_import_title = const TextStyle(
    color: Colours.text_gray,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  // Wallet: login
  static const TextStyle login_seg1 = const TextStyle(
    color: Colours.text_light,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle login_seg2 = const TextStyle(
    color: Colors.white,
    fontSize: Dimens.font_sp14,
    fontWeight: FontWeight.w600,
  );

  // Guide: mnem
  static const TextStyle guide_mnem_index = const TextStyle(
    color: Colours.text_light,
    fontFamily: "D-DIN",
    fontSize: 9,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle guide_mnem_title = const TextStyle(
    color: Colors.white60,
    fontFamily: "D-DIN",
    fontSize: 10,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle guide_mnem_select = const TextStyle(
    color: Colors.white,
    fontFamily: "D-DIN",
    fontSize: 10,
    fontWeight: FontWeight.w600,
  );

  // Wallet: home
  static const TextStyle wallet_panel_button = const TextStyle(
    fontSize: 13,
    color: Colors.white,
  );
  static const TextStyle wallet_asset_title = const TextStyle(
    fontSize: 13,
    color: Colors.white,
  );
  static const TextStyle transmit_amount = const TextStyle(
    color: Colors.black87,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle transmit_usdt = const TextStyle(
    color: Colors.black45,
    fontSize: 13,
  );
  static const TextStyle transmit_hash = const TextStyle(
    color: Colours.app_main,
    fontSize: 11,
  );
  static const TextStyle token_detail_button = const TextStyle(
    color: Colors.white,
    fontSize: 12,
  );

  // Wallet: manage
  static const TextStyle wallet_manage_private = const TextStyle(
    color: Colours.text_gray,
    fontFamily: "D-DIN",
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  // Wallet: token
  static const TextStyle switch_token_name = const TextStyle(
    fontSize: 13,
    color: Colours.text,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle token_name = const TextStyle(
    fontSize: 14,
    color: Colours.text,
    fontWeight: FontWeight.w500,
  );

  // Token: transfer
  static const TextStyle token_transfer_title = const TextStyle(
    color: Colors.white,
    fontSize: 12,
  );
  static const TextStyle token_transfer_place1 = const TextStyle(
    color: Color(0xFFCCCCDD),
    fontSize: 13,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle token_transfer_place2 = const TextStyle(
    color: Color(0xFFCCCCDD),
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle token_transfer_address = const TextStyle(
    color: Colours.text,
    fontFamily: "D-DIN",
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle token_transfer_amount = const TextStyle(
    color: Colours.text,
    fontSize: 18,
    fontFamily: "D-DIN",
    fontWeight: FontWeight.w600,
  );
  static const TextStyle token_transfer_all = const TextStyle(
    color: Color(0xFF657AC2),
    fontSize: 13,
    fontFamily: "D-DIN",
    fontWeight: FontWeight.w500,
  );
  static const TextStyle token_transfer_available = const TextStyle(
    fontSize: 12,
    color: Colours.app_main,
    fontFamily: "D-DIN",
    fontWeight: FontWeight.w500,
  );
  static const TextStyle transfer_sheet_title = const TextStyle(
    fontSize: 14,
    color: Colors.white,
    fontFamily: "D-DIN",
    fontWeight: FontWeight.w600,
  );
  static const TextStyle transfer_sheet_assist = const TextStyle(
    fontSize: 12,
    color: Colours.app_main,
    fontFamily: "D-DIN",
    fontWeight: FontWeight.w600,
  );

  // Token: transaction
  static const TextStyle transaction_amount = const TextStyle(
    fontSize: 16,
    color: Colors.white,
    fontFamily: "D-DIN",
    fontWeight: FontWeight.w600,
  );

  static const TextStyle transaction_status = const TextStyle(
    fontSize: 12,
    color: Colours.text_light,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle transaction_title = const TextStyle(
    fontSize: 12,
    color: Color(0xFF9999AA),
    fontWeight: FontWeight.w400,
  );

  static const TextStyle transaction_content = const TextStyle(
    fontSize: 12,
    color: Color(0xFFeeeeee),
    fontFamily: "D-DIN",
    fontWeight: FontWeight.w500,
  );

  static const TextStyle transaction_gas = const TextStyle(
    fontSize: 11,
    color: Color(0xFF999999),
    fontFamily: "D-DIN",
    fontWeight: FontWeight.w500,
  );

  // Token: receive
  static const TextStyle token_receive_title = const TextStyle(
    fontSize: 14,
    color: Colours.text,
    fontFamily: "D-DIN",
    fontWeight: FontWeight.w600,
  );
  static const TextStyle token_receive_address = const TextStyle(
    fontSize: 12,
    color: Colours.text_light,
    fontFamily: "D-DIN",
    fontWeight: FontWeight.w500,
  );
  static const TextStyle token_receive_tips = const TextStyle(
    color: Colors.black54,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle token_receive_button = const TextStyle(
    color: Colors.white,
    fontSize: 13,
  );

  // Token: add
  static const TextStyle token_add_seg1 = const TextStyle(
    fontSize: 12,
    color: Colours.text_light,
    fontFamily: "D-DIN",
    fontWeight: FontWeight.w500,
  );
  static const TextStyle token_add_seg2 = const TextStyle(
    fontSize: 13,
    color: Colours.text,
    fontFamily: "D-DIN",
    fontWeight: FontWeight.w600,
  );
  static const TextStyle token_add_title = const TextStyle(
    fontSize: 15,
    color: Colours.text,
    fontFamily: "D-DIN",
    fontWeight: FontWeight.w600,
  );
  static const TextStyle alert_delete_content = const TextStyle(
    fontSize: 14,
    color: Colors.white70,
    fontFamily: "D-DIN",
    fontWeight: FontWeight.w500,
  );
  static const TextStyle token_add_desc = const TextStyle(
    fontSize: 13,
    color: Colours.text_light,
    fontFamily: "D-DIN",
    fontWeight: FontWeight.w600,
  );
  static const TextStyle token_add_address = const TextStyle(
    fontSize: 12,
    color: Colours.text_light,
    fontFamily: "D-DIN",
    fontWeight: FontWeight.w500,
  );

  // Token: nft
  static const TextStyle token_nft_name = const TextStyle(
    fontSize: 12,
    color: Colors.white,
    fontFamily: "D-DIN",
    fontWeight: FontWeight.w600,
  );
  static const TextStyle token_nft_content = const TextStyle(
    fontSize: 11,
    color: Colors.white,
    fontFamily: "D-DIN",
    fontWeight: FontWeight.w600,
  );

  static const TextStyle token_nft_button = const TextStyle(
    fontSize: 13,
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );

  // nft: history
  static const TextStyle nft_history_receive = const TextStyle(
    fontSize: 14,
    color: Colours.green,
    fontFamily: "D-DIN",
    fontWeight: FontWeight.w600,
  );

  static const TextStyle nft_history_send = const TextStyle(
    fontSize: 14,
    color: Colours.app_main,
    fontFamily: "D-DIN",
    fontWeight: FontWeight.w600,
  );

  static const TextStyle nft_history_title = const TextStyle(
    fontSize: 14,
    color: Colours.text,
    fontFamily: "D-DIN",
    fontWeight: FontWeight.w500,
  );

  static const TextStyle nft_history_time = const TextStyle(
    fontSize: 13,
    color: Colours.text_gray,
    fontFamily: "D-DIN",
    fontWeight: FontWeight.w500,
  );

  static const TextStyle nft_history_hash = const TextStyle(
    fontSize: 13,
    color: Color(0xFF999999),
    fontFamily: "D-DIN",
    fontWeight: FontWeight.w500,
  );

  // Dapp: home
  static const TextStyle dapp_name = const TextStyle(
    fontSize: Dimens.font_sp15,
    color: Colours.text,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle dapp_detail_title = const TextStyle(
    color: Colours.text_gray,
    fontSize: Dimens.font_sp14,
  );
  static const TextStyle dapp_sheet_button = const TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle dapp_warn_title = const TextStyle(
    color: Colors.white,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle dapp_warn_content = const TextStyle(
    color: Colours.text_light,
    fontSize: 11,
  );

  // Dapp: search
  static const TextStyle dapp_search_place = const TextStyle(
    fontSize: Dimens.font_sp14,
    color: Colours.text_gray,
  );
  static const TextStyle dapp_tagtext_light = const TextStyle(
    color: Colours.app_main,
    fontSize: 10,
  );
  static const TextStyle dapp_tagtext_dark = const TextStyle(
    color: Colours.text,
    fontFamily: "D-DIN",
    fontSize: 10,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle dapp_search_title = const TextStyle(
    color: Colors.white70,
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );

  // My: home
  static const TextStyle my_title = const TextStyle(
    fontSize: Dimens.font_sp14,
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );

  // My: settings
  static const TextStyle my_setting_title = const TextStyle(
    color: Colors.white,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle my_setting_desc = const TextStyle(
    fontSize: Dimens.font_sp12,
    color: Colours.text_gray,
    fontWeight: FontWeight.normal,
  );
  static const TextStyle my_username = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w600,
    fontSize: 18,
  );
  static const TextStyle password_place = const TextStyle(
    color: Color(0xFFCCCCDD),
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
}
