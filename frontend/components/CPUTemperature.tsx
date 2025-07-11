import { useEffect, useState } from "react";
import { invoke } from "@tauri-apps/api/core";

type Temperature = {
    label: string;
    temp: number;
};

export default function CPUTemperature() {
    const [temps, setTemps] = useState<Temperature[]>([]);

    useEffect(() => {
        const interval = setInterval(() => {
            invoke<[string, number][]>("get_cpu_temperature").then((res) => {
                setTemps(res.map(([label, temp]) => ({ label, temp })));
            });
        }, 2000);

        return () => clearInterval(interval);
    }, []);

    return (
        <div className="temperatureContainer">
            <h2>Température CPU</h2>
            {temps.map((t, idx) => (
                <div key={idx}>
                    <span>{t.label}</span> : {t.temp.toFixed(1)} °C
                </div>
            ))}
        </div>
    );
}
