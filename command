
cd c:\Users\Professional\myDjangoFolder\personalPortfolio-project\
python manage.py runserver

git add -A
git commit -m "after p39, lesson 5.4"
git push -u origin master

https://www.pythonanywhere.com bash:
cd django4-personal-portfolio/
workon portfoliovenv

workon portfoliovenv        -вход в виртуальное окружение 'portfoliovenv'
deactivate                  -выход
узнать все доступные вирт окруж(2 строки):
cd .virtualenvs/
ls

pwd текущий путь


GIT

git init    - в папке проекта, добавл его в git.

После установки:
git config --global user.email johndoe@example.com
git config --global user.name "John Doe"

git status     состояние git
git add -A     копир изменен в обл Stage
git commit -m "our first commit! "      - наш первый commit
git stash       отменяет все измен до последнего Commit`a
git log    список Commit`ов
git checkout + желтый номер в списке Commit`ов.

Для git hub (в хабе есть подсказка для команд)
git remote add origin https://github.com/Alexgkz/НАЗВАНИЕ ПРОекта в хабе.git
git branch -M master
git push -u origin master


Новый проект Django

1)django-admin startproject personal_portfolio    создан проекта и папки
2)python manage.py startapp blog    добавл приложен(папку) блог
3)python manage.py startapp portfolio   то же портфолио
4)эти приложения добавляем в список INSTALLED_APPS файла Settings.py основного приложения
5) python manage.py runserver    запуск сервера


6) В models.py добавить Класс и модели класса(виды объектов django field model)
7)pip3 install pillow
8)python manage.py makemigrations   - ввод изменений в модели, (после каждого изменения model)
8.1) python manage.py migrate тоже,
9)python manage.py createsuperuser  log:alex pas:xxxxx смена пароля python manage.py changepassword Alex
10)в файл admin.py   добавим какие модели будут доступны из админки (from .models import Project)
10.1)  и admin.site.register(Project)
зашли в админку там появилась папка Projects где можно +add добавлять "проекты" с моделями класса Project
11) добавили 1 экземпляр Progect object(1) через +add, но файл сохранился в /portfolio/image, a мы хотели в папке project/media/Images для этого в settings.py добавим
    MEDIA_ROOT = os.path.join(BASE_DIR, 'media')
12)Если в админке нажать на имя файла для отобр, будет ошибка исправим:
  в файл urls.py добавим
    from django.conf.urls.static import static

  в файл settings.py
    MEDIA_URL = 'media/'

в файл urls.py добавим
      from django.conf import settings
вниз
      urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
13) Chekpoint, before lesson 4.5
14) сайт НЕ ОТОБРАЖАЕТСЯ с домашней страницы, т.к. нет данных прописанных в настройках проекта
надо создать стартовую страницу
15) импортируем все модели в код домашней страницы во view.py
projects = Project.objects.all()
  return render(request, 'portfolio/home.html', {'projects':projects})
16)добавим в home.html {{ projects }} чтобы увидеть содержимое объекта(его __call__
просто убедиться что данные импортировались
чтобы просмотреть весь список сменим двойные фигурн скобки на одинарные с % и пройдем циклом.
{% for project in projects %}
{{ project }}
{% endfor %}
(для доступа из страницы к списку {{ xxx   }}  к словарю {% xxxx %} синтаксис django)
так мы получим вывод имен экземпляров проекта (у нас пока 1: project object(1)
если мы к элементу списка добавим через точку названия модели из .Model, то получим содержимое этого элемента класса
{% for project in projects %}
{{ project.title }}       >  "my first project"
{{ project.description }}  > "This is my Description"
{% endfor %}
17)В итоге с выводом картинки и небольшим форматированием Вывод заголовка, коментария, картинки с размером в пикселях

{% for project in projects %}
<h2>{{ project.title }}</h2>
<p>{{ project.description }}</p>
<img src="{{ project.image.url }}" height=220 width=180>
{% if project.url %}
<a href="{{ project.url }}">Link</a>
{% endif %}

{% endfor %}


если project.url существует то надо отобразить содержимое тега <a>:
{% if project.url %}
<br><a href="{{ project.url }}">Link</a>
{% endif %}
br - возрат коретки

Теперь мы можем через админку добавлять сколько угодно страниц, блогов и т.д.

18) lesson 4.6 можем переходить к другим страницам по названию blog/:
  path('blog/', include('blog.urls')),    - urls.py
  вместо path('',views.home, name='home'),

  надо создать в папке blog файл urls.py:

  from django.urls import path
  from . import views

  urlpatterns = [
      path('',views.all_blogs, name='all_blogs'
  ]

  как делали в personal_portfolio.
  также делаем файл views.py в папке blog для страницы all_blogs:

  from django.shortcuts import render

  def all_blogs(request):
      return render(request, 'blog/all_blogs.html')

  далее делаем файл all_blogs.html аналогично personal_portfolio

  в итоге все запросы включающие(include) "blog/" названии будут искаться в приложении blog и его файле urls.py

19) создаю страницу blogs со списком блогов

20) во views.py добавим .order_by('-data')[:5] вместо .all()

def home(request):
    projects = Project.objects.all()
    return render(request, 'portfolio/home.html', {'projects':projects})
блоги будут отсортированны по дате и будут выведены последние 5 штук

21) добавляем статические файлы котор не могут изменить пользователи из админки
например картинка на заглавной странице home.html
{% load static %}

<img src="{% static 'portfolio/1.jpg' %}">


{% load static %} - обязательно перед любым обращениям к статик файлам, для которых мы сделали папку static/portfolio
папка static прописана в STATIC_URL = 'static/' (setting.py), а путь к файлу:
  portfolio\static\portfolio\1.jpg
  Ссылка на сскачивание файла
  <a href="{% static 'portfolio/2.pdf' %}">Certificate</a>

22) p.4.10 Detail Здесь мы сделаем так чтобы автоматически создавались ссылки на каждый экземпляр блога по его ID.
Для этого urls.py добавляем строку:
        path('<int:blog_id/>',views.detail, name='detail'),
в views.py добавляем функцию:
      def detail(request, blog_id):
          return render(request, 'blog/detail.html', {'id':blog_id})
  создаем файл detail.html для шаблона блога(пока только id):
  {{ id }}
  после этих добавлений пришлось перезапустить сервер
  после всего этого у нас при наборе url=http://127.0.0.1:8000/blog/11/
  выводится страница с цифрой '11' ({{ id }}

23) Для связи со страницей блога делаем следуюющее:
в views.py изменяем функцию detail:
    from django.shortcuts import render, get_object_or_404
      def detail(request, blog_id):
          blog = get_object_or_404(Blog, pk=blog_id)
          return render(request, 'blog/detail.html', {'blog':blog})
изменяем файл detail.html для шаблона блога(пока только заголовок):
          {{ blog.title }}
после всего этого у нас при наборе url=http://127.0.0.1:8000/blog/2/
выводится заголовок блога blog.title, если такого экземпляра(№2) нет то будет ОШИБКА 404 'нет страницы'

24) для того что выводилась страница блога нажатием на заголовок на странице all_blogs
дорабатываем all_blogs.html (href="{% url 'detail' blog.id %}):
<h2><a href="{% url 'detail' blog.id %}" {{ blog.title }}</a></h2>
25) это работает, но не совсем так как надо, если у нас будет несколько приложений
в сайте с применением detailб то надо чтобы джанго их раздичала для этого
в blog/urls.py добавим:
    app_name = 'blog'
  и чтобы не было ошибки в all_blogs.html добавим 'blog:', чтобы джанго знала
  что эту функцию 'detail' искать во views.py приложения app_name = 'blog'
  <h2><a href="{% url 'blog:detail' blog.id %}">{{ blog.title }}</a></h2>
26) lesson 4.11 счетчик блоков в all_blogs.html
<h2>Alex has written {{blogs.count }} blog{{ blogs.count|pluralize }}</h2>
{{ blogs.count|pluralize }} - добавляет букву "s" к словам во множественном числе.
27) перенастройка формата вывода даты
<h5>{{ blog.data|date:'M d Y' }}</h5>
28) ограничение количества (100) выводимых символов не используя срезы
<p>{{ blog.description|safe|truncatechars:100 }}</p>
29) чтобы в тексте работали теги <b></b>, <p></p> и др. добавим |safe до truncatechars
<p>{{ blog.description|safe|truncatechars:100 }}</p>
30)если вместо safe ввести striptags, то теги деактивируются и уберутся из выведенного текста
31)добавили дату в detail.html
<h2>-- {{ blog.data|date:'F jS Y' }} --</h2>
вывод: --February 17th 2023--      #  jS -это буквы th после даты
32) Добавили текст description в detail.
{{ blog.description|safe }}


33) чтобы в админке вместо blog object 1, blog object 2... выводились заголовки блогов
для Blog или заголовки приложений для portfolio добавляем в их model.py в нужный класс:
      def __str__(self):
          return self.title
34) lesson 4.12 улучшение с bootstrap. Добавление строки навигации сверху.
1)Зашли на https://getbootstrap.com/docs/5.3/getting-started/introduction/
скопировали готовый шаблон и поместили свою html страницу в тег Body
2) в Bootstrap в поиске набрали navbar, нашли страницу и скопировали скрипт в body
перед кодом страницы.
3) тоже самое (1-2)можем сделать  для all_blogs, detail.
Но это неудобно, поэтому обычно делают шаблон страницы который редактируется 1 раз для всех страниц.
Создаем файл base.html и копируем туда содержимое home.html. убираем текст тела страницы кроме bootstrap.
и вместо этого тела добавляем {% block content %}{% endblock %}

теперь во всех файлах страниц .html добаляем сначала код:
{% extends 'portfolio/base.html' %}

{% block content %}

и в конце:
{% endblock %}
Это позволит загрузить базовую страницу 'portfolio/base.html' и
вставит то что между тегами {% block content %}  {% endblock %} между этими же тегами
в базовой странице.

Вот теперь выполняем пункт 3 для all_blogs, detail. Все страницы в едином стиле.

35)lesson 4.13. настройка navbar добавка страницы About2

 РАЗВОРАЧИВАНИЕ сайта https://www.pythonanywhere.com

 36) lesson 5.1 зарегистрировались в https://www.pythonanywhere.com и зашли в $Bash в нижнем левом углу.
 (это консоль linux витртуального сервера )
 там ввели команду git clone https://github.com/Alexgkz/django4-personal-portfolio.git и скопировали проект с GitHub
 37) les 5.2 перешли в папку django4-personal-portfolio.git  cd django4-personal-portfolio.git
 и ввели mkvirtualenv --python=/usr/bin/python3.8 portfoliovenv -что устанавливает python3.8(.10 по факту) в виртуальное окружение с именем 'portfoliovenv'
 workon portfoliovenv       -вход в виртуальное окружение 'portfoliovenv' если вышли из Bash
 установим django  и pillow:
 pip install django pillow
 38) les 5.3 зайдем в папку проекта cd django4-personal-portfolio/
 и введя pwd узнаем полный путь к приложению.
 Дальше в браузере заходим в раздел WEB  на сайте https://www.pythonanywhere.com.
 наажимаем кнопку +Add a new web app/ там будет предупреждение, что в бесплатном аккаунте адрес сайта будет Alexgkz.pythonanywhere.com
 далее можно выбрать фреймворк Django и сделать все в автомате, но мы выберем мануал.
 в следующем окне выберем python3.8 и далее 2 раза пока не появится Configuration for Alexgkz.pythonanywhere.com

 в разделе Virtualenv:  вводим название вирт окружен portfoliovenv и нажимаем ввод.

 в разделе Сode меняем Source code: это путь к проекту '/home/Alexgkz/django4-personal-portfolio'
 в разделе Сode меняем Working directory: это путь к проекту '/home/Alexgkz/django4-personal-portfolio'
 в нашем случае они совпадают.

в разделе Сode щелкаем по файлу WSGI configuration file:/var/www/alexgkz_pythonanywhere_com_wsgi.py
и оставляем только раздел Django  остальное удаляем.
он "за'комент'ирован", раз'коммент'ируем выделив все кроме:
# +++++++++++ DJANGO +++++++++++
# To use your own django app use code like this:
и нажав ctrl+/
далее изменить путь path = '/home/Alexgkz/django4-personal-portfolio'
os.environ['DJANGO_SETTINGS_MODULE'] = 'personal_portfolio.settings' изменим путь к файлу setting.py как к модулю через точку
нажать кнопку  Save (зеленая в верхней строке)
перейдем на гл страницу https://www.pythonanywhere.com/user/Alexgkz/ нажав на питона в верхнем левом углу.
 заходим в раздел WEB. перегружаем сайт нажав кнопку 'Reload Alexgkz.pythonanywhere.com'.

 надо в файле setting.py внести изменения с помощью редактора:
в странице Web  в разделе Сode  Source code: нажимаем go to directory ищем файл изменяем и сохраняем и делаем ReLoad.
'ReLoad Alexgkz.pythonanywhere.com' надо делать при любом изменении в проекте.
сайт загрузится но пока не настроены static файлы и др. мелочи.

39) less 5.4 зайдем в файл setting.py и поменяем  DEBUG = True на DEBUG = False,
это отключит встроенный дебаг Джанго. и в случае ошибок не будут разглашаться данные проекта.
Далее для вывода статических файлов добавляем нижнюю строку:
STATIC_URL = '/static/'
STATIC_ROOT = os.path.join(BASE_DIR, 'static')  -это подскажет где искать файлы static.
теперь в консоле pythonanywhere.com' зайдем в папку где находится manage.py (~/django4-personal-portfolio)
вводим команду которая скопирует все статические файлы (всех приложений проекта )в папку,
которая выведется после выполнения команды: /home/Alexgkz/django4-personal-portfolio/static
мы ее задали выше.
На странице WEB в разделе Static files:
в столбе URL вставим /static/
в столбе Directory вставим /home/Alexgkz/django4-personal-portfolio/static
что значит все значения в URL /static/ искать в папке /home/Alexgkz/django4-personal-portfolio/static

делаем тоже самое для media файлов:
На странице WEB в разделе Static files:
в столбе URL вставим /media/
в столбе Directory вставим /home/Alexgkz/django4-personal-portfolio/media
что значит все значения в URL /media/ искать в папке /home/Alexgkz/django4-personal-portfolio/media

На странице WEB в разделе Security:   кнопку  Force HTTPS: сделать enabled.
для постоянно защищенного соединения.
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
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
40) les 5.5 Создаем файл gitignore чтобы указать что не надо обновлять из github.
для этого вводим в браузере gitignore.io пишем django нажимаем Enter и нажимаем Create.
появляется большой файл из которого нас интересует только начало:
### Django ###
*.log
*.pot
*.pyc
__pycache__/
local_settings.py

в консоле pythonanywhere.com' зайдем в папку /django4-personal-portfolio и введем команду:
nano .gitignore и добавим строчки выше. ctrl+x выход с сохр изменений.
далее вводим git add .gitignore
git config --global user.email 'alexgkz@mail.ru'
git config --global user.name "Alexgkz"
git commit -m "p40 l5.5 gitignore added"


созданные файлы все равно не удаляются из git status .
что бы все работало как надо надо ввести две команды:
git rm -r --cached .
git add .
и  вводим git commit -m "Remove old stuff" чтобы ввести изменения в буфер и удалим не нужные файлы

делаем изменение на github чтобы правки в коде перешли в репозит надо знать username и token:
git push origin или
git push origin HEAD:main

41) less 5.6  чтобы изменения на сервере не влияли на работу сайта на локальном компе сделаем следующие:
в папке personal_portfolio\ создадим файл local_settings.py
а в конце оригинального файла settings.py допишем:
try:
    from .local_settings import *     
except ImportError:
    print("Looks like no local file. You must be on production")
	
- этим мы заменяем настройки в settings.py теми которые есть в local_settings.py
а на Prodaction (сервер) local_settings.py через git передаваться не будет.


	


