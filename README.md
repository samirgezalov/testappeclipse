ТЗ
Стек: Flutter.
Используя сервис https://jsonplaceholder.typicode.com/ реализовать псевдо-приложение/
Список экранов:
1. Список пользователей. Вывод списка, полученного по апи в виде карточек вида 
  [
username
name
  ]
2. Страница пользователя. Подробный вывод информации о пользователе
  [
    в AppBar - username
    (далее по списку)
name
email
phone
website
working(company)[
name
bs
catchPhrase (курсив, какцитата)
]
adress
    список из 3-х превью (заголовок, 1 строчка текста...) постов пользователя + возможность посмотреть все (экран 3)
    список из 3-х превью альбомов пользователя с миниатюрой + возможность посмотреть все (экран 4)
  ]
3. список постов пользователя. Все посты в формате превью + возможность перейти на детальную (экран 5)
4. список альбомов пользователя
5. детальная страница поста со списком всех комментариев c именем и email. так же, внизу экрана добавить кнопку добавления комментария. По клику открывается форма с 3 полями имя, email, текс комментария и кнопкой "отправить/send" (на выбор: отдельный экран, модальное окно, bottomSheet). Отправку сделать на тот же сервис.
6. детальная альбома. Все фото альбома с описанием и слайдером
Требования к внешнему виду: понятный интерфейс на Ваш вкус.
 
Дополнительное задание:
Кэшировать все ответы от сервиса, т.е. по мере использования приложения создавать дубликат данных. Например, запросили пользователей – закэшировали, запросили альбомы пользователя, отправили комментарий к посту, закэшировали. И при каждом запросе проверять кэш на наличие данных, если они имеются отдавать из кэша, отсутствуют запросили с сервиса. Реализация кэша на ваш выбор (SharedPreferences, hive, SQLite, и т.д.).
