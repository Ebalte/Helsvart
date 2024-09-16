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
            max-width: 400px;
            background-color: rgba(255, 255, 255, 0.9);
            border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0,0,0,0.5);
        }
        .modal-content {
            padding: 20px;
            border: 1px solid #888;
            color: black;
            display: flex;
            flex-direction: column;
            align-items: center;
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
        .modal-title {
            display: flex;
            align-items: center;
            margin-top: 10px;
            margin-bottom: 10px;
            width: 100%;
        }
        .upgrade-info, .settings-info {
            margin-top: 10px;
            font-size: 16px;
            color: #333;
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
            <div id="additionalUpgrades"></div>
            <p id="modalMessage"></p>
        </div>
    </div>

    <div id="achievementModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal('achievementModal')">&times;</span>
            <h2>Достижения</h2>
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
            { type: 1, count: 0, baseCost: 10, increment: 2, maxUses: 15 },
            { type: 2, count: 0, baseCost: 50, increment: 0.1, maxUses: 15 },
            { type: 3, count: 0, baseCost: 500, increment: 10, maxUses: 15 },
            { type: 4, count: 0, baseCost: 450, increment: 1, maxUses: 15 },
            { type: 5, count: 0, baseCost: 5000, increment: 100, maxUses: 15 },
            { type: 6, count: 0, baseCost: 4500, increment: 10, maxUses: 15 },
            { type: 7, count: 0, baseCost: 200, increment: 5, maxUses: 10 },
            { type: 8, count: 0, baseCost: 1000, increment: 50, maxUses: 10 },
            { type: 9, count: 0, baseCost: 2000, increment: 1, maxUses: 10 }
        ];

        document.getElementById("score").innerText = score.toFixed(1);
        document.getElementById("pointsPerClick").innerText = pointsPerClick;
        document.getElementById("passiveIncome").innerText = passiveIncome.toFixed(1);

        function toggleMusic() {
            const music = document.getElementById('backgroundMusic');
            musicEnabled = document.getElementById('musicToggle').checked;
            if (musicEnabled) {
                music.play().catch(error => {
                    console.log("Автоматическое воспроизведение заблокировано:", error);
                });
            } else {
                music.pause();
            }
        }

        function toggleSound() {
            soundEnabled = document.getElementById('soundToggle').checked;
        }

        function applyPromoCode() {
            const promoCode = document.getElementById('promoCodeInput').value;
            if (promoCode === "PROMO2024") {
                score += 100; // Например, добавить 100 баллов
                document.getElementById("score").innerText = score.toFixed(1);
                localStorage.setItem("score", score);
                document.getElementById('modalMessage').innerText = 'Промокод принят! Вы получили 100 баллов.';
            } else {
                document.getElementById('modalMessage').innerText = 'Неверный промокод.';
            }
            document.getElementById('promoCodeInput').value = ''; // Очистить поле ввода
        }

        window.onload = function() {
            if (musicEnabled) {
                const music = document.getElementById('backgroundMusic');
                music.play().catch(error => {
                    console.log("Автоматическое воспроизведение заблокировано:", error);
                });
            }
            document.getElementById('musicToggle').checked = musicEnabled;
            document.getElementById('soundToggle').checked = soundEnabled;
            document.getElementById('musicToggle').addEventListener('change', toggleMusic);
            document.getElementById('soundToggle').addEventListener('change', toggleSound);
        };

        setInterval(() => {
            score += passiveIncome;
            document.getElementById("score").innerText = score.toFixed(1);
            localStorage.setItem("score", score);
        }, 1000);

        document.getElementById("scoreButton").onclick = function() {
            score += pointsPerClick;
            document.getElementById("score").innerText = score.toFixed(1);
            localStorage.setItem("score", score);
        };

        function openUpgradeModal() {
            document.getElementById('upgradeModal').style.display = "block";
            renderAdditionalUpgrades();
        }

        function openAchievementModal() {
            document.getElementById('achievementModal').style.display = "block";
        }

        function openSettingsModal() {
            document.getElementById('settingsModal').style.display = "block";
        }

        function closeModal(modalId) {
            document.getElementById(modalId).style.display = "none";
            document.getElementById('modalMessage').innerText = '';
        }

        function renderAdditionalUpgrades() {
            const container = document.getElementById('additionalUpgrades');
            container.innerHTML = '';

            upgrades.forEach(upgrade => {
                if (upgrade.count < upgrade.maxUses) {
                    const cost = upgrade.baseCost * Math.pow(2, upgrade.count); // Увеличение стоимости
                    const button = document.createElement('button');
                    button.className = 'small-button';
                    button.innerText = `Улучшение ${upgrade.type}: ${upgrade.increment} за ${cost} (Использовано ${upgrade.count}/${upgrade.maxUses})`;
                    button.onclick = () => buyUpgrade(upgrade, cost);
                    container.appendChild(button);
                }
            });
        }

        function buyUpgrade(upgrade, cost) {
            if (score >= cost) {
                score -= cost;
                if (upgrade.type === 1) {
                    pointsPerClick *= upgrade.increment;
                } else if (upgrade.type === 2) {
                    passiveIncome += upgrade.increment;
                } else if (upgrade.type === 3) {
                    pointsPerClick *= upgrade.increment;
                } else if (upgrade.type === 4) {
                    passiveIncome += upgrade.increment;
                } else if (upgrade.type === 5) {
                    pointsPerClick *= upgrade.increment;
                } else if (upgrade.type === 6) {
                    passiveIncome += upgrade.increment;
                } else if (upgrade.type === 7) {
                    pointsPerClick += upgrade.increment;
                } else if (upgrade.type === 8) {
                    pointsPerClick += upgrade.increment;
                } else if (upgrade.type === 9) {
                    passiveIncome += upgrade.increment;
                }
                upgrade.count += 1;
                document.getElementById("score").innerText = score.toFixed(1);
                document.getElementById("pointsPerClick").innerText = pointsPerClick;
                document.getElementById("passiveIncome").innerText = passiveIncome.toFixed(1);
                localStorage.setItem("score", score);
                document.getElementById('modalMessage').innerText = 'Улучшение куплено!';
                renderAdditionalUpgrades(); // Перерисовываем улучшения
            } else {
                document.getElementById('modalMessage').innerText = 'Недостаточно баллов для покупки!';
            }
        }

        window.onclick = function(event) {
            if (event.target == document.getElementById('upgradeModal') || event.target == document.getElementById('achievementModal') || event.target == document.getElementById('settingsModal')) {
                closeModal(event.target.id);
            }
        };
    </script>
</body>
</html>
