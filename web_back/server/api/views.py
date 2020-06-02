from django.http import HttpResponseBadRequest
from rest_framework.response import Response
from rest_framework.views import APIView
from .models import User, Comment, Photo
from .serializers import UserSerializer, PhotoSerializer, CommentSerializer
from django.core.exceptions import ObjectDoesNotExist


class UserView(APIView):

    def get(self, request):
        users = User.objects.all()
        serializer = UserSerializer(users, many=True)
        return Response({"users": serializer.data})

    def post(self, request):
        user = request.data
        serializer = UserSerializer(data=user)
        user_saved = None
        if serializer.is_valid(raise_exception=True):
            user_saved = serializer.save()
        return Response({"success": f"User created successfully"})


class UserOneView(APIView):

    def post(self, request):
        try:
            email, password = request.data['email'], request.data['password']
        except KeyError:
            return HttpResponseBadRequest

        try:
            user = User.objects.get(email=email, password=password)
        except ObjectDoesNotExist:
            return HttpResponseBadRequest

        serializer = UserSerializer(user)
        return Response(serializer.data)


class UserUpdate(APIView):

    def post(self, request):
        print(request.data)
        users = User.objects.get(id=request.data['id'])
        users.name = request.data['name']
        users.surname = request.data['surname']
        users.birth_date = request.data['birth_date']
        users.save()
        return Response()


class PhotoView(APIView):

    def get(self, request):
        photos = Photo.objects.all()
        serializer = PhotoSerializer(photos, many=True)
        return Response({"photos": serializer.data})

    def post(self, request):
        photo = request.data
        serializer = PhotoSerializer(data=photo)
        photo_saved = None
        if serializer.is_valid(raise_exception=True):
            photo_saved = serializer.save()
        return Response({"success": f"Photo created successfully"})


class CommentView(APIView):

    def get(self, request):
        comments = Comment.objects.all()
        serializer = CommentSerializer(comments, many=True)
        return Response({"comments": serializer.data})

    def post(self, request):
        comment = request.data
        serializer = CommentSerializer(data=comment)
        comment_saved = None
        if serializer.is_valid(raise_exception=True):
            comment_saved = serializer.save()
        return Response({"success": f"Comment created successfully"})


class CommentOneView(APIView):
    def post(self, request):
        try:
            photo_id = request.data['photo_id']
        except KeyError:
            return HttpResponseBadRequest

        try:
            comment = Comment.objects.filter(photo=photo_id)
        except ObjectDoesNotExist:
            return HttpResponseBadRequest

        comments = CommentSerializer(comment, many=True).data
        for comment_ in comments:
            user = User.objects.filter(id=comment_['author'])
            comment_['name'] = UserSerializer(user, many=True).data[0]['name']
            comment_['surname'] = UserSerializer(user, many=True).data[0]['surname']
        return Response({"comments": comments})
