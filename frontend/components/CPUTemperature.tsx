import { useEffect, useState } from "react";
import { invoke } from "@tauri-apps/api/core";

type Temperature = {
    label: string;
    temp: number;
};

export default function CPUTemperature() {
    const [temps, setTemps] = useState<Temperature[]>([]);
    const [mainTemp, setMainTemp] = useState<Temperature | null>(null);

    useEffect(() => {
        const interval = setInterval(() => {
            invoke<[string, number][]>("get_cpu_temperature").then((res) => {
                const tempsFormatted = res.map(([label, temp]) => ({
                    label,
                    temp,
                }));
                setTemps(tempsFormatted);

                // Trouver la température la plus élevée
                const hottest = tempsFormatted.reduce(
                    (max, t) => (t.temp > max.temp ? t : max),
                    tempsFormatted[0]
                );
                setMainTemp(hottest);
            });
        }, 2000);

        return () => clearInterval(interval);
    }, []);

    return (
        <div className="temperatureContainer">
            <h2>Température CPU</h2>
            {mainTemp && (
                <div
                    style={{
                        color:
                            mainTemp.temp.toFixed(1) > "60"
                                ? "#F97316"
                                : mainTemp.temp.toFixed(1) > "80"
                                ? "#DC2626"
                                : "#10B981",
                    }}
                    className="temp">
                    {mainTemp.temp.toFixed(1)} °C
                </div>
            )}

            <details>
                <summary>Voir tous les capteurs</summary>
                {temps.map((t, idx) => (
                    <div key={idx}>
                        <span>{t.label}</span> : {t.temp.toFixed(1)} °C
                    </div>
                ))}
            </details>
        </div>
    );
}
