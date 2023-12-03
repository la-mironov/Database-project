<!DOCTYPE html>
<h1> CHECKING... </h1>
<?php
// Подключение к базе данных
$host = "ssh.cloud.nstu.ru:5311";
$port = "5432";
$dbname = "the_library_system_of_the_city";
$user = "admin";
$password = "bdproekt2023";

// Устанавливаем соединение с базой данных
$conn = pg_connect("host=$host port=$port dbname=$dbname user=$user password=$password");

if (!$conn) {
    die("Ошибка подключения: " . pg_last_error());
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $phone_number = $_POST['phone_number'];

    // Проверка номера телефона
    $query = "SELECT * FROM human_contacts WHERE phone_num = $1";
    $result = pg_query_params($conn, $query, array($phone_number));

    if (!$result) {
        die("Ошибка запроса: " . pg_last_error());
    }

    $count = pg_num_rows($result);
    if ($count = 1) {
        // Пользователь найден
        echo "Вход выполнен успешно!";
    } else {
        // Пользователь не найден
        echo "Неверный номер телефона";
    }
}
?>
