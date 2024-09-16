<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Счетчик Балов</title>
    <style>
        body {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100vh;
            font-family: Arial, sans-serif;
            background-color: #f0f0f0;
        }
        button {
            padding: 10px 20px;
            font-size: 18px;
            cursor: pointer;
        }
        h1 {
            font-size: 24px;
        }
    </style>
</head>
<body>
    <h1>Ваши баллы: <span id="score">0</span></h1>
    <button id="scoreButton">Получить 1 балл</button>

    <script>
        // Загружаем количество баллов из localStorage
        let score = localStorage.getItem("score") ? parseInt(localStorage.getItem("score")) : 0;
        document.getElementById("score").innerText = score;

        document.getElementById("scoreButton").onclick = function() {
            score += 1;
            document.getElementById("score").innerText = score;
            // Сохраняем количество баллов в localStorage
            localStorage.setItem("score", score);
        };
    </script>
</body>
</html>
