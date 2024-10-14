# README
Описание проекта

Данное приложение предназначено для мониторинга доступности и скорости отклика заданных URL с сохранением истории и 
статистики. Оно включает в себя следующие основные компоненты:

Модели:

    Endpoint — хранит информацию об URL и параметрах опроса.
    EndpointStatus — хранит текущий статус каждого URL.
    HistoryDay — ведет статистику опросов по дням.

Сервисы:

    StatusService — обновляет текущий статус для каждого Endpoint.
    HistoryService — сохраняет и обновляет историю опросов.

Задачи:

    PingEndpointJob — запускает опросы URL с заданной периодичностью.

Запуск приложения локально

Чтобы запустить приложение на локальной машине, выполните следующие шаги:

    Настройте подключение к Postgres и Redis.

Установите необходимые зависимости:

```bash
bundle install
```

Создайте и примените миграции для базы данных:

```bash
rails db:create
rails db:migrate
```

Запустите Sidekiq для обработки фоновых задач:

```bash
bundle exec sidekiq
```

Запустите сервер приложения:

```bash
bin/dev
```

Откройте приложение в браузере: Перейдите по адресу http://localhost:3000/.

Добавьте Endpoint через веб-интерфейс: На главной странице вы сможете добавить новый Endpoint, указав:

    Название
    URL для мониторинга
    Плановое время ответа (в миллисекундах)
    Периодичность опроса (в секундах)

После добавления приложение начнет опрашивать указанный URL с заданной частотой. 
В колонке History (Last 7 Days) будет отображаться индикатор статуса для каждого дня. 
Данные по Endpoint обновляются в режиме реального времени без необходимости перезагрузки 
страницы.

(Опционально) Загрузите тестовые данные: В консоли выполните команду:

```bash
rails db:seed
```
После этого обновите страницу для загрузки тестовых данных.
![img.png](img.png)