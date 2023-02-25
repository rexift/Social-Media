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
      final comment = Comment.fromJson(map);

      return _post(context, comment);

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
  final dbComments = await db.comments.queryComments();

  var sharedComments = <Comment>[];

  if (dbComments.isNotEmpty) {
    sharedComments = dbComments.map(Comment.fromDb).toList();
  }

  return Response.json(
    body: {
      'comments': sharedComments,
    },
  );
}

Future<Response> _post(RequestContext context, Comment comment) async {
  final database = context.read<Database>();

  final request = db.CommentInsertRequest(
    uid: comment.uid,
    content: comment.content,
  );

  final id = await database.comments.insertOne(request);

  return Response.json(
    body: {
      'comment': 'Comment has been added with ID: $id',
    },
  );
}
