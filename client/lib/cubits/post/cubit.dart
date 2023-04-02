import 'dart:async';

import 'package:client/constants/constants.dart';
import 'package:client/services/api.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

part 'state.dart';
part '_comment_state.dart';
part '_create_state.dart';
part '_delete_state.dart';
part '_edit_state.dart';
part '_fetch_all_state.dart';
part '_like_state.dart';
part '_share_state.dart';

part 'data_provider.dart';
part 'repository.dart';

class PostCubit extends Cubit<PostState> {
  static PostCubit c(BuildContext context, [bool listen = false]) =>
      BlocProvider.of<PostCubit>(context, listen: listen);
  PostCubit() : super(const PostStateDefault());

  final repo = _PostRepository();

  Future<void> fetchAll() async {
    emit(state.copyWith(
      fetchAll: PostFetchAllLoading(),
    ));
    try {
      final data = await repo.fetchAll();
      emit(state.copyWith(
        posts: data,
        fetchAll: const PostFetchAllSuccess(),
      ));
    } catch (e) {
      emit(state.copyWith(
        fetchAll: PostFetchAllFailed(message: e.toString()),
      ));
    }
  }

  Future<void> createPost(
    int uid,
    String caption, {
    bool? hasImage,
    String? imageURL,
    bool? hasVideo,
    String? videoURL,
  }) async {
    emit(state.copyWith(
      create: PostCreateLoading(),
    ));
    try {
      final data = await repo.createPost(
        uid,
        caption,
        hasImage,
        imageURL,
        hasVideo,
        videoURL,
      );

      state.posts!.add(data);

      emit(state.copyWith(
        create: const PostCreateSuccess(),
      ));
    } catch (e) {
      emit(state.copyWith(
        create: PostCreateFailed(message: e.toString()),
      ));
    }
  }

  Future<void> editPost(int postId, String caption) async {
    emit(state.copyWith(
      edit: PostEditLoading(),
    ));
    try {
      await repo.editPost(postId, caption);

      final post = state.posts!.firstWhere((post) => post.id == postId);
      final postIndex = state.posts!.indexOf(post);
      final updatedPost = post.copyWith(caption: caption);
      state.posts![postIndex] = updatedPost;

      emit(state.copyWith(
        edit: const PostEditSuccess(),
      ));
    } catch (e) {
      emit(state.copyWith(
        edit: PostEditFailed(message: e.toString()),
      ));
    }
  }

  Future<void> deletePost(int postId, String url) async {
    emit(state.copyWith(
      delete: PostDeleteLoading(),
    ));
    try {
      await repo.deletePost(postId, url);

      state.posts!.removeWhere(
        (post) => post.id == postId,
      );

      emit(state.copyWith(
        delete: const PostDeleteSuccess(),
      ));
    } catch (e) {
      emit(state.copyWith(
        delete: PostDeleteFailed(message: e.toString()),
      ));
    }
  }
}