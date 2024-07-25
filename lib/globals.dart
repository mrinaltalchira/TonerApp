// Define your global variables here
import 'package:Trako/screens/authFlow/signin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Trako/color/colors.dart';

const double radiusTextField = 21.0;
const double radiusContainerTextField = 21.0;
const double heightEditText = 50.0;
const double appBarIconHeight = 30.0;


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void navigateToAuthProcess() {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    navigatorKey.currentState?.pushReplacement(
      MaterialPageRoute(
        builder: (context) => const AuthProcess(),
      ),
    );
  });
}

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      backgroundColor: colorMixGrad,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}

class CustomImageWidget extends StatelessWidget {
  final String? imageUrl;
  final IconData? iconData;
  final double? width;
  final double? height;
  final double? radius;
  final bool isNetworkImage;
  final VoidCallback? onTap;

  const CustomImageWidget({
    Key? key,
    this.imageUrl,
    this.iconData,
    this.width,
    this.height,
    this.radius = 0,
    this.isNetworkImage = true,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius!),
        child: _buildChild(),
      ),
    );
  }

  Widget _buildChild() {
    if (imageUrl != null && isNetworkImage) {
      return Image.network(
        imageUrl!,
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    } else if (imageUrl != null && !isNetworkImage) {
      return Image.asset(
        imageUrl!,
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    } else if (iconData != null) {
      return Icon(
        iconData,
        size: width ?? height ?? 24,
      );
    } else {
      // Placeholder or default widget when imageUrl and iconData are null
      return Container(
        color: Colors.grey[300],
        width: width,
        height: height,
        child: Center(
          child: Text(
            'No Image',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }
  }
}

class NoDataWidget extends StatelessWidget {
  final String message;
  final String imagePath;

  const NoDataWidget({
    Key? key,
    this.message = "No data found",
    this.imagePath = "assets/no_data.png", // Example image path
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 150.0,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 24.0),
            Text(
              message,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.0),
            Text(
              "Please try again later.",
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class NoDataFoundWidget extends StatefulWidget {
  final Future<void> Function() onRefresh;

  const NoDataFoundWidget({required this.onRefresh, Key? key}) : super(key: key);

  @override
  _NoDataFoundWidgetState createState() => _NoDataFoundWidgetState();
}

class _NoDataFoundWidgetState extends State<NoDataFoundWidget> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 100),
          // Image
          Image.asset(
            'assets/images/ic_no_data.jpg', // Replace with your image asset
            width: 120,
            height: 120,
          ),
          // Text
          Text(
            'No Data Found',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          // Subtext
          Text(
            'It looks like there is no data available for this request.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
          // Button (optional)
          const SizedBox(height: 20),
          _isLoading
              ? const CircularProgressIndicator()
              : SizedBox(
            width: 120,
            child: GradientButton(
              gradientColors: const [colorMixGrad, colorMixGrad],
              height: 45.0,
              width: 10.0,
              radius: 25.0,
              buttonText: "Try Again",
              onPressed: _handleRefresh,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isLoading = true;
    });
    print("Loading started");
    try {
      await widget.onRefresh();
      print("API called");
    } catch (e) {
      print("Error: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        print("Loading finished");
      }
    }
  }
}


class ConfirmSubmitDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const ConfirmSubmitDialog({Key? key, required this.onConfirm})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 4),
            blurRadius: 8.0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              'Confirm Submit',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: colorMixGrad, // Use colorMixGrad as the primary color
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Divider(
            color: Colors.grey,
            height: 0.5,
          ),
          const SizedBox(height: 8.0),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Are you sure you want to submit?',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 14.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  onConfirm(); // Call the callback to submit
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorMixGrad,
                  // Use colorMixGrad as the primary color
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                ),
                child: const Text(
                  'Confirm',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
