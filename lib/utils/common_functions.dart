import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

Future<bool> isNetworkAvailable() async {
  try {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    } else if (connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.mobile)) {
      return true;
    }
  } catch (e) {
    return false;
  }

  return false;
}

// Assuming 'winner.date' is in UTC format as a String
String formatDateToIST(String utcDate) {
  DateTime utcDateTime = DateTime.parse(utcDate).toUtc(); // Parse the UTC date
  DateTime istDateTime =
      utcDateTime.add(const Duration(hours: 5, minutes: 30)); // Convert to IST

  // Format the date to 12-hour clock with 'am'/'pm'
  String formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(istDateTime);
  return formattedDate;
}

Future<void> openDiscord(String yourChannelId) async {
  // Discord App URL scheme
  const discordAppUrl = "discord://discordapp.com/channels/yourChannelId";
  const discordWebUrl = "https://discord.gg/HbRaMBa7";

  if (await canLaunch(discordAppUrl)) {
    await launch(discordAppUrl);
  } else if (await canLaunch(discordWebUrl)) {
    await launch(discordWebUrl);
  } else {
    throw 'Could not launch Discord';
  }
}

/// Launches Discord with the given invite link
/// Returns true if successful, false otherwise
Future<bool> openDiscordChannel(String inviteLink) async {
  try {
    // Clean the invite link to remove any extra characters
    final cleanInviteCode = inviteLink
        .replaceAll('https://discord.gg/', '')
        .replaceAll('discord.gg/', '')
        .replaceAll('/', '');


    final Uri discordWebUri = Uri.parse('https://discord.gg/HbRaMBa7');

    // Check if Discord app is installed

    // Fallback to web version
    final bool webLaunched = await launchUrl(
      discordWebUri,
      mode: LaunchMode.externalApplication,
    );

    return webLaunched;
  } catch (e) {
    print('Error launching Discord: $e');
    return false;
  }
}
Future<bool> openDiscordChannel2(String code) async {
  try {
    // 1. First just try the simple web URL
    final Uri url = Uri.parse('https://discord.gg/$code');

    // 2. Debug print to verify URL
    print('Attempting to launch URL: $url');

    // 3. Simple launch with default browser
    return await launchUrl(
      url,
      mode: LaunchMode.platformDefault, // Use platform default browser
      webViewConfiguration: const WebViewConfiguration(
        enableJavaScript: true,
        enableDomStorage: true,
      ),
    );
  } catch (e) {
    print('Detailed error info:');
    print('Error type: ${e.runtimeType}');
    print('Error message: $e');
    return false;
  }
}
Future<bool> openInstagramChannel2() async {
  try {
    // 1. First just try the simple web URL
    final Uri url = Uri.parse('https://www.instagram.com/__daksh21__/');

    // 2. Debug print to verify URL
    print('Attempting to launch URL: $url');

    // 3. Simple launch with default browser
    return await launchUrl(
      url,
      mode: LaunchMode.platformDefault, // Use platform default browser
      webViewConfiguration: const WebViewConfiguration(
        enableJavaScript: true,
        enableDomStorage: true,
      ),
    );
  } catch (e) {
    print('Detailed error info:');
    print('Error type: ${e.runtimeType}');
    print('Error message: $e');
    return false;
  }
}

// Example usage with detailed error reporting
void launchDiscord(BuildContext context, String code) async {
  try {
    final result = await openDiscordChannel2(code);
    print('Launch result: $result');

    if (!result && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open Discord link'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  } catch (e) {
    print('Error in launchDiscord: $e');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}