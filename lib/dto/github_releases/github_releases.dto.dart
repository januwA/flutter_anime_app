library github_releases.dto;

import 'dart:convert';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter_video_app/dto/github_releases/serializers.dart';

part 'github_releases.dto.g.dart';

abstract class GithubReleasesDto
    implements Built<GithubReleasesDto, GithubReleasesDtoBuilder> {
  GithubReleasesDto._();

  factory GithubReleasesDto([updates(GithubReleasesDtoBuilder b)]) =
      _$GithubReleasesDto;

  @BuiltValueField(wireName: 'url')
  String get url;

  @BuiltValueField(wireName: 'assets_url')
  String get assetsUrl;

  @BuiltValueField(wireName: 'upload_url')
  String get uploadUrl;

  @BuiltValueField(wireName: 'html_url')
  String get htmlUrl;

  @BuiltValueField(wireName: 'id')
  int get id;

  @BuiltValueField(wireName: 'node_id')
  String get nodeId;

  @BuiltValueField(wireName: 'tag_name')
  String get tagName;

  @BuiltValueField(wireName: 'target_commitish')
  String get targetCommitish;

  @BuiltValueField(wireName: 'name')
  String get name;

  @BuiltValueField(wireName: 'draft')
  bool get draft;

  @BuiltValueField(wireName: 'author')
  AuthorDto get author;

  @BuiltValueField(wireName: 'prerelease')
  bool get prerelease;

  @BuiltValueField(wireName: 'created_at')
  String get createdAt;

  @BuiltValueField(wireName: 'published_at')
  String get publishedAt;

  @BuiltValueField(wireName: 'assets')
  BuiltList<AssetsDto> get assets;

  @BuiltValueField(wireName: 'tarball_url')
  String get tarballUrl;

  @BuiltValueField(wireName: 'zipball_url')
  String get zipballUrl;

  @BuiltValueField(wireName: 'body')
  String get body;

  String toJson() {
    return jsonEncode(
        serializers.serializeWith(GithubReleasesDto.serializer, this));
  }

  static GithubReleasesDto fromJson(String jsonString) {
    return serializers.deserializeWith(
        GithubReleasesDto.serializer, jsonDecode(jsonString));
  }

  static Serializer<GithubReleasesDto> get serializer =>
      _$githubReleasesDtoSerializer;
}

abstract class AuthorDto implements Built<AuthorDto, AuthorDtoBuilder> {
  AuthorDto._();

  factory AuthorDto([updates(AuthorDtoBuilder b)]) = _$AuthorDto;

  @BuiltValueField(wireName: 'login')
  String get login;

  @BuiltValueField(wireName: 'id')
  int get id;

  @BuiltValueField(wireName: 'node_id')
  String get nodeId;

  @BuiltValueField(wireName: 'avatar_url')
  String get avatarUrl;

  @BuiltValueField(wireName: 'gravatar_id')
  String get gravatarId;

  @BuiltValueField(wireName: 'url')
  String get url;

  @BuiltValueField(wireName: 'html_url')
  String get htmlUrl;

  @BuiltValueField(wireName: 'followers_url')
  String get followersUrl;

  @BuiltValueField(wireName: 'following_url')
  String get followingUrl;

  @BuiltValueField(wireName: 'gists_url')
  String get gistsUrl;

  @BuiltValueField(wireName: 'starred_url')
  String get starredUrl;

  @BuiltValueField(wireName: 'subscriptions_url')
  String get subscriptionsUrl;

  @BuiltValueField(wireName: 'organizations_url')
  String get organizationsUrl;

  @BuiltValueField(wireName: 'repos_url')
  String get reposUrl;

  @BuiltValueField(wireName: 'events_url')
  String get eventsUrl;

  @BuiltValueField(wireName: 'received_events_url')
  String get receivedEventsUrl;

  @BuiltValueField(wireName: 'type')
  String get type;

  @BuiltValueField(wireName: 'site_admin')
  bool get siteAdmin;

  String toJson() {
    return jsonEncode(serializers.serializeWith(AuthorDto.serializer, this));
  }

  static AuthorDto fromJson(String jsonString) {
    return serializers.deserializeWith(
        AuthorDto.serializer, jsonDecode(jsonString));
  }

  static Serializer<AuthorDto> get serializer => _$authorDtoSerializer;
}

abstract class AssetsDto implements Built<AssetsDto, AssetsDtoBuilder> {
  AssetsDto._();

  factory AssetsDto([updates(AssetsDtoBuilder b)]) = _$AssetsDto;

  @BuiltValueField(wireName: 'url')
  String get url;

  @BuiltValueField(wireName: 'id')
  int get id;

  @BuiltValueField(wireName: 'node_id')
  String get nodeId;

  @BuiltValueField(wireName: 'name')
  String get name;

  @nullable
  @BuiltValueField(wireName: 'label')
  Null get label;

  @BuiltValueField(wireName: 'uploader')
  UploaderDto get uploader;

  @BuiltValueField(wireName: 'content_type')
  String get contentType;

  @BuiltValueField(wireName: 'state')
  String get state;

  @BuiltValueField(wireName: 'size')
  int get size;

  @BuiltValueField(wireName: 'download_count')
  int get downloadCount;

  @BuiltValueField(wireName: 'created_at')
  String get createdAt;

  @BuiltValueField(wireName: 'updated_at')
  String get updatedAt;

  @BuiltValueField(wireName: 'browser_download_url')
  String get browserDownloadUrl;

  String toJson() {
    return jsonEncode(serializers.serializeWith(AssetsDto.serializer, this));
  }

  static AssetsDto fromJson(String jsonString) {
    return serializers.deserializeWith(
        AssetsDto.serializer, jsonDecode(jsonString));
  }

  static Serializer<AssetsDto> get serializer => _$assetsDtoSerializer;
}

abstract class UploaderDto implements Built<UploaderDto, UploaderDtoBuilder> {
  UploaderDto._();

  factory UploaderDto([updates(UploaderDtoBuilder b)]) = _$UploaderDto;

  @BuiltValueField(wireName: 'login')
  String get login;

  @BuiltValueField(wireName: 'id')
  int get id;

  @BuiltValueField(wireName: 'node_id')
  String get nodeId;

  @BuiltValueField(wireName: 'avatar_url')
  String get avatarUrl;

  @BuiltValueField(wireName: 'gravatar_id')
  String get gravatarId;

  @BuiltValueField(wireName: 'url')
  String get url;

  @BuiltValueField(wireName: 'html_url')
  String get htmlUrl;

  @BuiltValueField(wireName: 'followers_url')
  String get followersUrl;

  @BuiltValueField(wireName: 'following_url')
  String get followingUrl;

  @BuiltValueField(wireName: 'gists_url')
  String get gistsUrl;

  @BuiltValueField(wireName: 'starred_url')
  String get starredUrl;

  @BuiltValueField(wireName: 'subscriptions_url')
  String get subscriptionsUrl;

  @BuiltValueField(wireName: 'organizations_url')
  String get organizationsUrl;

  @BuiltValueField(wireName: 'repos_url')
  String get reposUrl;

  @BuiltValueField(wireName: 'events_url')
  String get eventsUrl;

  @BuiltValueField(wireName: 'received_events_url')
  String get receivedEventsUrl;

  @BuiltValueField(wireName: 'type')
  String get type;

  @BuiltValueField(wireName: 'site_admin')
  bool get siteAdmin;

  String toJson() {
    return jsonEncode(serializers.serializeWith(UploaderDto.serializer, this));
  }

  static UploaderDto fromJson(String jsonString) {
    return serializers.deserializeWith(
        UploaderDto.serializer, jsonDecode(jsonString));
  }

  static Serializer<UploaderDto> get serializer => _$uploaderDtoSerializer;
}
