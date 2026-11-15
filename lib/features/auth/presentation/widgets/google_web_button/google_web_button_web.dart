import 'package:flutter/material.dart';
import 'package:google_sign_in_web/web_only.dart' as web;

Widget buildGoogleWebButton({
  required bool isSignUp,
  VoidCallback? onPressed,
}) {
  return SizedBox(
    width: double.infinity,
    height: 50,
    child: Center(
      child: web.renderButton(
        configuration: web.GSIButtonConfiguration(
          type: web.GSIButtonType.standard,
          theme: web.GSIButtonTheme.outline,
          size: web.GSIButtonSize.large,
          text: isSignUp
              ? web.GSIButtonText.signupWith
              : web.GSIButtonText.signinWith,
          shape: web.GSIButtonShape.rectangular,
          logoAlignment: web.GSIButtonLogoAlignment.left,
          minimumWidth: 320,
        ),
      ),
    ),
  );
}
