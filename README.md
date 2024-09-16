<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Счетчик Баллов</title>
    <style>
        body {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: flex-start;
            height: 100vh;
            font-family: Arial, sans-serif;
            background-color: #000;
            color: #fff;
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        #scoreButton {
            width: 80vmin;
            height: 80vmin;
            border-radius: 50%;
            background-color: #fff;
            background-image: url('https://sun9-53.userapi.com/impg/-XApqPO8d5D0l-y3_KvP39yPyi68JPLcU8i80Q/gW-b2OjEJOA.jpg?size=1280x1280&quality=95&sign=e54e4442564b152dbb30fbdfab36d3e1&type=album');
            background-size: cover;
            background-position: center;
            border: none;
            cursor: pointer;
            margin: 20px 0;
        }
        .button-container {
            display: flex;
            justify-content: center;
            width: 100%;
            margin-top: 10px;
            flex-wrap: wrap;
        }
        .small-button {
            height: 60px; 
            width: 200px;
            border-radius: 30px;
            background-color: #000;
            color: #fff;
            border: 2px solid #fff;
            cursor: pointer;
            margin: 5px;
            font-size: 16px;
        }
        .modal {
            display: none;
            position: fixed;
            z-index: 1;
            left: 50%;
            top: 50%;
            transform: translate(-50%, -50%);
            width: 80%;
            max-width: 500px;
            background-color: rgba(255, 255, 255, 0.9);
            border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0,0,0,0.5);
            overflow: hidden;
        }
        .modal-content {
            padding: 20px;
            color: black;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        .modal-title {
            display: flex;
            align-items: center;
            margin-top: 10px;
            margin-bottom: 10px;
            width: 100%;
        }
        .modal-body {
            overflow-y: auto;
            max-height: 60vh; /* Высота модального окна с ползунком */
            width: 100%;
        }
        .modal-body::-webkit-scrollbar {
            width: 12px;
        }
        .modal-body::-webkit-scrollbar-track {
            background: #f1f1f1;
        }
        .modal-body::-webkit-scrollbar-thumb {
            background: #888;
            border-radius: 10px;
        }
        .modal-body::-webkit-scrollbar-thumb:hover {
            background: #555;
        }
        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
        }
        .close:hover,
        .close:focus {
            color: red;
            text-decoration: none;
            cursor: pointer;
        }
        h1, h2 {
            margin: 5px;
        }
        .upgrade-item, .achievement-item {
            margin: 5px;
            font-size: 16px;
            color: #000;
            display: flex;
            align-items: center;
            padding: 10px;
            border-radius: 10px;
            background-color: #fff;
            box-shadow: 0px 0px 5px rgba(0,0,0,0.3);
            cursor: pointer;
        }
        .upgrade-item:hover, .achievement-item:hover {
            background-color: #f1f1f1;
        }
        .upgrade-item img, .achievement-item img {
            width: 40px;
            height: 40px;
            margin-right: 10px;
            border-radius: 50%;
        }
        .settings-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            width: 100%;
        }
        .settings-container label {
            margin: 5px;
            font-size: 16px;
        }
        .settings-container input[type="text"] {
            width: 100%;
            max-width: 250px;
            padding: 10px;
            margin-top: 10px;
            border-radius: 5px;
            border: 1px solid #ccc;
        }
    </style>
</head>
<body>
    <h1>тапок: <span id="score">0</span></h1>
    <h2>тапок за каждое нажатие: <span id="pointsPerClick">1</span></h2>
    <h2>Пассивный доход: <span id="passiveIncome">0.0</span> в секунду</h2> 
    <button id="scoreButton"></button>

    <div class="button-container">
        <button class="small-button" onclick="openUpgradeModal()">Улучшения</button>
        <button class="small-button" onclick="openAchievementModal()">Достижения</button>
        <button class="small-button" onclick="openSettingsModal()">Настройки</button>
    </div>

    <div id="upgradeModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal('upgradeModal')">&times;</span>
            <div class="modal-title">
                <h2>Улучшения</h2>
            </div>
            <div class="modal-body" id="additionalUpgrades"></div>
            <p id="modalMessage"></p>
        </div>
    </div>

    <div id="achievementModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal('achievementModal')">&times;</span>
            <h2>Достижения</h2>
            <div class="modal-body" id="achievementsList"></div>
            <p id="achievementMessage"></p>
        </div>
    </div>

    <div id="settingsModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal('settingsModal')">&times;</span>
            <h2>Настройки</h2>
            <div class="settings-container">
                <label>
                    <input type="checkbox" id="musicToggle"> Включить музыку
                </label>
                <label>
                    <input type="checkbox" id="soundToggle"> Включить звук
                </label>
                <input type="text" id="promoCodeInput" placeholder="Введите промокод">
                <button class="small-button" onclick="applyPromoCode()">Применить промокод</button>
                <button class="small-button" onclick="openTelegramBot()">Открыть Telegram Бот</button>
                <button class="small-button" onclick="resetProgress()">Сбросить прогресс</button>
            </div>
        </div>
    </div>

    <!-- Добавляем тег <audio> для музыки -->
    <audio id="backgroundMusic" loop>
        <source src="file:///C:/Users/ebalte/Downloads/kk/my_music.mp3" type="audio/mpeg">
        Ваш браузер не поддерживает аудио.
    </audio>

    <script>
        let pointsPerClick = 1;
        let score = localStorage.getItem("score") ? parseFloat(localStorage.getItem("score")) : 0;
        let passiveIncome = 0;
        let musicEnabled = true;
        let soundEnabled = true;

        let upgrades = [
            { type: 1, count: 0, baseCost: 10, increment: 2, maxUses: 15, image: 'path/to/upgrade1.png' },
            { type: 2, count: 0, baseCost: 50, increment: 0.1, maxUses: 15, image: 'path/to/upgrade2.png' },
            { type: 3, count: 0, baseCost: 500, increment: 10, maxUses: 15, image: 'path/to/upgrade3.png' },
            { type: 4, count: 0, baseCost: 450, increment: 1, maxUses: 15, image: 'path/to/upgrade4.png' },
            { type: 5, count: 0, baseCost: 5000, increment: 100, maxUses: 15, image: 'path/to/upgrade5.png' },
            { type: 6, count: 0, baseCost: 5000, increment: 1, maxUses: 15, image: 'path/to/upgrade6.png' },
            { type: 7, count: 0, baseCost: 50000, increment: 1000, maxUses: 15, image: 'path/to/upgrade7.png' },
            { type: 8, count: 0, baseCost: 100000, increment: 1000, maxUses: 15, image: 'path/to/upgrade8.png' },
            { type: 9, count: 0, baseCost: 2000000, increment: 2000, maxUses: 15, image: 'path/to/upgrade9.png' },
        ];

        let achievements = [
            { threshold: 100, achieved: false, reward: 0.33 },
            { threshold: 1000, achieved: false, reward: 0.33 },
            { threshold: 10000, achieved: false, reward: 0.33 },
            { threshold: 100000, achieved: false, reward: 0.33 },
            { threshold: 1000000, achieved: false, reward: 0.33 },
            { threshold: 10000000, achieved: false, reward: 0.33 },
            { threshold: 100000000, achieved: false, reward: 0.33 },
            { threshold: 1000000000, achieved: false, reward: 0.33 },
        ];

        let achievementsByUpgrades = [
            { threshold: 1, achieved: false, reward: 0.33 },
            { threshold: 10, achieved: false, reward: 0.33 },
            { threshold: 100, achieved: false, reward: 0.33 },
            { threshold: 1000, achieved: false, reward: 0.33 },
            { threshold: 10000, achieved: false, reward: 0.33 },
            { threshold: 100000, achieved: false, reward: 0.33 },
            { threshold: 1000000, achieved: false, reward: 0.33 },
            { threshold: 10000000, achieved: false, reward: 0.33 },
        ];

        document.getElementById("score").innerText = score.toFixed(1);
        document.getElementById("pointsPerClick").innerText = pointsPerClick;
        document.getElementById("passiveIncome").innerText = passiveIncome.toFixed(1);

        // Обработчик нажатия на главную кнопку
        document.getElementById('scoreButton').onclick = function() {
            addPoints();
        };

        function addPoints() {
            score += pointsPerClick;
            document.getElementById("score").innerText = score.toFixed(1);
            localStorage.setItem("score", score);
            checkAchievements(); // Проверяем достижения после добавления очков
        }

        function openModal(id) {
            document.getElementById(id).style.display = "block";
        }

        function closeModal(id) {
            document.getElementById(id).style.display = "none";
        }

        function openUpgradeModal() {
            openModal('upgradeModal');
            renderAdditionalUpgrades();
        }

        function openAchievementModal() {
            openModal('achievementModal');
            renderAchievements();
        }

        function openSettingsModal() {
            openModal('settingsModal');
        }

        function renderAdditionalUpgrades() {
            const container = document.getElementById('additionalUpgrades');
            container.innerHTML = '';

            upgrades.forEach(upgrade => {
                const upgradeItem = document.createElement('div');
                upgradeItem.className = 'upgrade-item';
                const img = document.createElement('img');
                img.src = upgrade.image;
                const text = document.createElement('span');
                text.innerText = `Улучшение ${upgrade.type} - Стоимость: ${upgrade.baseCost} баллов, Количество: ${upgrade.count}`;
                upgradeItem.appendChild(img);
                upgradeItem.appendChild(text);
                const upgradeButton = document.createElement('button');
                upgradeButton.className = 'small-button';
                upgradeButton.innerText = 'Купить';
                upgradeButton.onclick = () => buyUpgrade(upgrade, upgrade.baseCost);
                container.appendChild(upgradeItem);
                container.appendChild(upgradeButton);
            });
        }

        function renderAchievements() {
            const container = document.getElementById('achievementsList');
            container.innerHTML = '';

            achievements.forEach(achievement => {
                const listItem = document.createElement('div');
                listItem.className = 'achievement-item';
                const img = document.createElement('img');
                img.src = 'path/to/achievement_icon.png'; // Замените на подходящую иконку
                const text = document.createElement('span');
                text.innerText = `Достижение за ${achievement.threshold} баллов - ${achievement.achieved ? 'Достигнуто' : 'Не достигнуто'}`;
                listItem.appendChild(img);
                listItem.appendChild(text);
                container.appendChild(listItem);
            });

            achievementsByUpgrades.forEach(achievement => {
                const listItem = document.createElement('div');
                listItem.className = 'achievement-item';
                const img = document.createElement('img');
                img.src = 'path/to/upgrade_icon.png'; // Замените на подходящую иконку
                const text = document.createElement('span');
                text.innerText = `Достижение за покупку ${achievement.threshold} улучшений - ${achievement.achieved ? 'Достигнуто' : 'Не достигнуто'}`;
                listItem.appendChild(img);
                listItem.appendChild(text);
                container.appendChild(listItem);
            });
        }

        function achievementsAchieved(achievement, type) {
            if (type === 'points') {
                score += score * achievement.reward;
                document.getElementById("score").innerText = score.toFixed(1);
                localStorage.setItem("score", score);
            } else if (type === 'upgrades') {
                score += score * achievement.reward;
                document.getElementById("score").innerText = score.toFixed(1);
                localStorage.setItem("score", score);
            }

            achievement.achieved = true;
            document.getElementById('achievementMessage').innerText = `Достижение выполнено: ${achievement.threshold} баллов! Вы получили ${Math.round(score * achievement.reward)} дополнительных баллов.`;

            renderAchievements();
        }

        function checkAchievements() {
            achievements.forEach(achievement => {
                if (!achievement.achieved && score >= achievement.threshold) {
                    achievementsAchieved(achievement, 'points');
                }
            });
        }

        function checkUpgradeAchievements() {
            achievementsByUpgrades.forEach(achievement => {
                if (!achievement.achieved && upgrades.some(u => u.count >= achievement.threshold)) {
                    achievementsAchieved(achievement, 'upgrades');
                }
            });
        }

     function buyUpgrade(upgrade, cost) {
    if (score >= cost) {
        score -= cost;
        if (upgrade.type === 1 || upgrade.type === 3 || upgrade.type === 5 || upgrade.type === 7 || upgrade.type === 8) {
            pointsPerClick += upgrade.increment;
        } else if (upgrade.type === 2 || upgrade.type === 4 || upgrade.type === 6 || upgrade.type === 9) {
            passiveIncome += upgrade.increment;
        }
        upgrade.count += 1;

        // Умножаем стоимость следующего улучшения на 5
        upgrade.baseCost *= 5;

        document.getElementById("score").innerText = score.toFixed(1);
        document.getElementById("pointsPerClick").innerText = pointsPerClick;
        document.getElementById("passiveIncome").innerText = passiveIncome.toFixed(1);
        localStorage.setItem("score", score);

        // Сохраняем улучшения в localStorage
        localStorage.setItem("upgrades", JSON.stringify(upgrades));

        document.getElementById('modalMessage').innerText = 'Улучшение куплено!';

        checkUpgradeAchievements();
        renderAdditionalUpgrades();
        renderAchievements(); // Обновляем список достижений
    } else {
        document.getElementById('modalMessage').innerText = 'Недостаточно баллов для покупки!';
    }
}



        function toggleMusic() {
            musicEnabled = !musicEnabled;
            const music = document.getElementById('backgroundMusic');
            if (musicEnabled) {
                music.play().catch(error => {
                    console.log("Автоматическое воспроизведение заблокировано:", error);
                });
            } else {
                music.pause();
            }
            localStorage.setItem('musicEnabled', musicEnabled);
        }

        function toggleSound() {
            soundEnabled = !soundEnabled;
            localStorage.setItem('soundEnabled', soundEnabled);
        }

        function applyPromoCode() {
            const promoCode = document.getElementById('promoCodeInput').value;
            alert('Промокод применен!');
            // Здесь можно добавить логику проверки и применения промокода
        }

        function openTelegramBot() {
            window.open('https://t.me/your_telegram_bot', '_blank');
        }

        function resetProgress() {
            if (confirm("Вы уверены, что хотите сбросить прогресс?")) {
                localStorage.removeItem("score");
                score = 0;
                pointsPerClick = 1;
                passiveIncome = 0;
                upgrades.forEach(upgrade => {
                    upgrade.count = 0;
                });
                document.getElementById("score").innerText = score.toFixed(1);
                document.getElementById("pointsPerClick").innerText = pointsPerClick;
                document.getElementById("passiveIncome").innerText = passiveIncome.toFixed(1);
                renderAdditionalUpgrades();
                renderAchievements();
            }
        }
      window.onload = function() {
    if (musicEnabled) {
        const music = document.getElementById('backgroundMusic');
        music.play().catch(error => {
            console.log("Автоматическое воспроизведение заблокировано:", error);
        });
    }
    renderAdditionalUpgrades();
    renderAchievements();

    // Восстанавливаем состояние улучшений из localStorage
    const savedUpgrades = localStorage.getItem("upgrades");
    if (savedUpgrades) {
        upgrades = JSON.parse(savedUpgrades);
    }

    // Обновляем отображение улучшений
    renderAdditionalUpgrades();
};
    </script>
</body>
</html>
