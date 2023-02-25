import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:db/db.dart' as db;
import 'package:shared/shared.dart';
import 'package:stormberry/stormberry.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _get(context);

    case HttpMethod.post:
      final request = await context.request.body();
      final map = jsonDecode(request) as Map<String, dynamic>;
      final post = Post.fromJson(map);

      return _post(context, post);

    //
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
    case HttpMethod.delete:
      return Response(statusCode: HttpStatus.methodNotAllowed);
    case HttpMethod.patch:
      return Response(statusCode: HttpStatus.methodNotAllowed);
    case HttpMethod.head:
      return Response(statusCode: HttpStatus.methodNotAllowed);
    case HttpMethod.options:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _get(RequestContext context) async {
  final db = context.read<Database>();
  final dbPosts = await db.posts.queryPosts();

  var sharedPosts = <Post>[];

  if (dbPosts.isNotEmpty) {
    sharedPosts = dbPosts.map(Post.fromDb).toList();
  }

  return Response.json(
    body: {
      'posts': sharedPosts,
    },
  );
}

Future<Response> _post(RequestContext context, Post post) async {
  final database = context.read<Database>();

  final request = db.PostInsertRequest(
    uid: post.uid,
    caption: post.caption,
    likes: [],
    createdAt: DateTime.now(),
  );

  final id = await database.posts.insertOne(request);

  return Response.json(
    body: {
      'post': 'Post has been added with ID: $id',
    },
  );
}
