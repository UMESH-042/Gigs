import 'package:flutter/material.dart';

// class LikeButtonAnimation extends StatefulWidget {
//   final Function() onTap;

//   const LikeButtonAnimation({Key? key, required this.onTap}) : super(key: key);

//   @override
//   _LikeButtonAnimationState createState() => _LikeButtonAnimationState();
// }

// class _LikeButtonAnimationState extends State<LikeButtonAnimation>
//     with TickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _scaleAnimation;

//   @override
//   void initState() {
//     super.initState();

//     _animationController =
//         AnimationController(vsync: this, duration: Duration(milliseconds: 200));
//     _scaleAnimation = Tween<double>(begin: 1, end: 1.5).animate(
//         CurvedAnimation(
//             parent: _animationController, curve: Curves.easeInOut));

//     _scaleAnimation.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         _animationController.reverse();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         widget.onTap();
//         _animationController.forward();
//       },
//       child: AnimatedBuilder(
//         animation: _animationController,
//         builder: (context, child) {
//           return Transform.scale(
//             scale: _scaleAnimation.value,
//             child: child,
//           );
//         },
//         child: Icon(
//           Icons.thumb_up,
//           color: Colors.blue,
//         ),
//       ),
//     );
//   }
// }


class LikeButtonAnimation extends StatefulWidget {
  final Function onTap;
  final bool isLiked;

  LikeButtonAnimation({required this.onTap, required this.isLiked});

  @override
  _LikeButtonAnimationState createState() => _LikeButtonAnimationState();
}

class _LikeButtonAnimationState extends State<LikeButtonAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Set initial state based on isLiked
    if (widget.isLiked) {
      _animationController.value = 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
        _handleTap();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Icon(
          widget.isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
          color: widget.isLiked ? Colors.grey : Colors.blue,
        ),
      ),
    );
  }

  void _handleTap() {
    if (widget.isLiked) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

