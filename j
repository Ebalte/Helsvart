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
        }
        #scoreButton {
            width: 350px;
            height: 350px;
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
        }
        .small-button {
            height: 75px; 
            width: 300px;
            border-radius: 30px;
            background-color: #000;
            color: #fff;
            border: 2px solid #fff;
            cursor: pointer;
            margin: 5px 0;
            font-size: 20px;
        }
        .modal {
            display: none;
            position: fixed;
            z-index: 1;
            left: 50%;
            top: calc(50% - 175px - 30%);
            transform: translateX(-50%);
            width: 350px;
            height: auto;
            overflow: auto;
            background-color: rgba(255, 255, 255, 0.9);
            border-radius: 10px;
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
        .upgrade-info {
            margin-top: 10px;
            font-size: 16px;
            color: #333;
        }
    </style>
</head>
<body>
    <h1>Ваши баллы: <span id="score">0</span></h1>
    <h2>Баллы за каждое нажатие: <span id="pointsPerClick">1</span></h2>
    <h2>Пассивный доход: <span id="passiveIncome">0.0</span> в секунду</h2> 
    <button id="scoreButton"></button>

    <div class="button-container">
        <button class="small-button" onclick="openUpgradeModal()">Улучшения</button>
        <button class="small-button" onclick="openAchievementModal()">Достижения</button> 
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

    <script>
        let pointsPerClick = 1;
        let score = localStorage.getItem("score") ? parseFloat(localStorage.getItem("score")) : 0;
        let passiveIncome = 0;
        let upgrades = [
            { type: 1, count: 0, baseCost: 10, increment: 2, maxUses: 15 },
            { type: 2, count: 0, baseCost: 50, increment: 0.1, maxUses: 15 },
            { type: 3, count: 0, baseCost: 500, increment: 10, maxUses: 15 },
            { type: 4, count: 0, baseCost: 450, increment: 1, maxUses: 15 },
            { type: 5, count: 0, baseCost: 5000, increment: 100, maxUses: 15 },
            { type: 6, count: 0, baseCost: 4500, increment: 10, maxUses: 15 },
            // Новые улучшения
            { type: 7, count: 0, baseCost: 200, increment: 5, maxUses: 10 },
            { type: 8, count: 0, baseCost: 1000, increment: 50, maxUses: 10 },
            { type: 9, count: 0, baseCost: 2000, increment: 1, maxUses: 10 }
        ];

        document.getElementById("score").innerText = score.toFixed(1);
        document.getElementById("pointsPerClick").innerText = pointsPerClick;
        document.getElementById("passiveIncome").innerText = passiveIncome.toFixed(1);

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
                    button.innerText = Улучшение ${upgrade.type}: ${upgrade.increment} за ${cost} (Использовано ${upgrade.count}/${upgrade.maxUses});
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
            if (event.target == document.getElementById('upgradeModal') || event.target == document.getElementById('achievementModal')) {
                closeModal(event.target.id);
            }
        };
    </script>
</body>
</html>
