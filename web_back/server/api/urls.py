from django.urls import path, include
from .views import UserView, CommentView, PhotoView, UserOneView, CommentOneView, UserUpdate

from api import views

urlpatterns = [
    path('users/', UserView.as_view()),
    path('comments/', CommentView.as_view()),
    path('photos/', PhotoView.as_view()),
    path('user/', UserOneView.as_view()),
    path('user/update', UserUpdate.as_view()),
    path('comment/', CommentOneView().as_view()),

]
