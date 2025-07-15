import { useEffect, useState } from "react";
import { invoke } from "@tauri-apps/api/core";

type Temperature = {
    label: string;
    temp: number;
};

export default function CPUTemperature() {
    const [temps, setTemps] = useState<Temperature[]>([]);
    const [mainTemp, setMainTemp] = useState<Temperature | null>(null);
    const [maxTemp, setMaxTemp] = useState<number>(0);

    useEffect(() => {
        const interval = setInterval(() => {
            invoke<[string, number][]>("get_cpu_temperature").then((res) => {
                const tempsFormatted = res.map(([label, temp]) => ({
                    label,
                    temp,
                }));
                setTemps(tempsFormatted);

                const hottest = tempsFormatted.reduce(
                    (max, t) => (t.temp > max.temp ? t : max),
                    tempsFormatted[0]
                );

                setMainTemp(hottest);

                if (hottest.temp > maxTemp) {
                    setMaxTemp(hottest.temp);
                }
            });
        }, 2000);

        return () => clearInterval(interval);
    }, [maxTemp]);

    return (
        <div className="temperatureContainer">
            <h2>Température CPU</h2>
            {mainTemp && (
                <div className="temp">
                    <p
                        style={{
                            color:
                                mainTemp.temp.toFixed(1) > "60"
                                    ? "#F97316"
                                    : mainTemp.temp.toFixed(1) > "80"
                                    ? "#DC2626"
                                    : "#10B981",
                        }}>
                        <span>T° :</span>
                        {mainTemp.temp.toFixed(1)} °C
                    </p>
                    <p
                        style={{
                            color:
                                maxTemp.toFixed(1) > "60"
                                    ? "#F97316"
                                    : maxTemp.toFixed(1) > "80"
                                    ? "#DC2626"
                                    : "#10B981",
                        }}>
                        <span>T° max :</span>
                        {maxTemp.toFixed(1)} °C
                    </p>
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
