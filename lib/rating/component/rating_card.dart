import 'package:flutter/material.dart';
import 'package:nosepack/common/const/colors.dart';
import 'package:collection/collection.dart';
import 'package:nosepack/rating/component/model/rating_model.dart';

class RatingCard extends StatelessWidget {
  final ImageProvider avatarImage; // CircleAvatar
  final List<Image> images;
  final int rating;
  final String email;
  final String content;

  const RatingCard(
      {Key? key,
      required this.avatarImage,
      required this.images,
      required this.rating,
      required this.email,
      required this.content})
      : super(key: key);

  factory RatingCard.fromModel({required RatingModel model}) {
    return RatingCard(
        avatarImage: NetworkImage(model.user.imageUrl),
        images: model.imgUrls.map((e) => Image.network(e)).toList(),
        rating: model.rating,
        email: model.user.username,
        content: model.content);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(
          avatarImage: avatarImage,
          email: email,
          rating: rating,
        ),
        const SizedBox(
          height: 8.0,
        ),
        _Body(content: content),
        if (images.length > 0)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: SizedBox(
                height: 100,
                child: _Images(
                  images: images,
                )),
          ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final ImageProvider avatarImage;
  final String email;
  final int rating;

  const _Header(
      {Key? key,
      required this.avatarImage,
      required this.email,
      required this.rating})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 12.0,
          backgroundImage: avatarImage,
        ),
        const SizedBox(
          width: 8.0,
        ),
        Expanded(
          child: Text(
            email,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 14.0,
                color: Colors.black,
                fontWeight: FontWeight.w500),
          ),
        ),
        ...List.generate(
            5,
            (index) => Icon(
                  index < rating ? Icons.star : Icons.star_border_outlined,
                  color: PRIMARY_COLOR,
                ))
      ],
    );
  }
}

class _Body extends StatelessWidget {
  final String content;

  const _Body({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          // 플렉서블 :: 글자가 넘어가도 다음줄로
          child: Text(
            content,
            style: TextStyle(color: BODY_TEXT_COLOR, fontSize: 14.0),
          ),
        ),
      ],
    );
  }
}

class _Images extends StatelessWidget {
  final List<Image> images;

  const _Images({Key? key, required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: images
          .mapIndexed((index, e) => Padding(
                padding: EdgeInsets.only(
                  right: index == images.length - 1.0 ? 0.0 : 16.0,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: e,
                ),
              ))
          .toList(),
    );
  }
}
