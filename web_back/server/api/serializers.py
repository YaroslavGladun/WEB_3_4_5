from rest_framework import serializers

from api.models import User, Photo, Comment


class UserSerializer(serializers.ModelSerializer):

    class Meta:
        model = User
        fields = ['name', 'surname', 'email', 'password', 'registration_date', 'id', 'birth_date']
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        return User.objects.create(**validated_data)


class PhotoSerializer(serializers.ModelSerializer):

    class Meta:
        model = Photo
        fields = ['photo_path', 'title', 'description', 'author', 'post_date_time', 'id']

    def create(self, validated_data):
        return Photo.objects.create(**validated_data)


class CommentSerializer(serializers.ModelSerializer):

    class Meta:
        model = Comment
        fields = ['text', 'photo', 'author', 'post_date_time']

    def create(self, validated_data):
        return Comment.objects.create(**validated_data)
