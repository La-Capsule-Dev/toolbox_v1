import { useEffect, useRef, useState } from "react";
import "./App.css";
import PDFViewer from "./components/tabs/PdfViewer";
import Tabs from "./components/tabs/Tabs";
import Terminal from "./components/tabs/Terminal";
import TestButton from "./components/testButtons/TestButton";
import testScripts from "./testScripts.json";
import { invoke } from "@tauri-apps/api/core";
import CPUTemperature from "./components/CPUTemperature";
import Popup from "./components/Popup";
import Feedback from "./components/Feedback";

function App() {
    const [feedbackType, setFeedbackType] = useState<
        "stress" | "micro" | "custom" | null
    >(null);
    const [micVolume, setMicVolume] = useState(0);
    const [PdfUrl, setPdfUrl] = useState<string>("");
    const [running, setRunning] = useState<boolean>(false);
    const [timeLeft, setTimeLeft] = useState<number>(190);
    const [visibility, setVisibility] = useState<"visible" | "hidden">(
        "hidden"
    );
    const [message, setMessage] = useState<string>("");
    const [color, setColor] = useState<"#F97316" | "#10b981">("#F97316");

    // Création de la session sudo (pkexec et sudo)
    const startSudoSession = async () => {
        try {
            await invoke("start_session");
        } catch (error) {
            console.log(error);
        }
    };

    // Lancement des scripts Rust
    const rust_script = (script: string) => {
        invoke(script);
    };

    // Lancement du stress test
    const startStressTest = async () => {
        try {
            const result = await invoke("stress_test");
            await invoke("play_stress_sound");

            setFeedbackType("stress");
            setTimeLeft(190);
            setRunning(true);
            setColor("#F97316");
            setVisibility("visible");
            setMessage("Lancement du stress test ...");
        } catch (e) {
            console.error("Erreur stress test :", e);
        }
    };

    useEffect(() => {
        let interval: number | undefined;
        if (running && timeLeft > 0) {
            interval = setInterval(() => {
                setTimeLeft((prev) => prev - 1);
            }, 1000);
        } else if (timeLeft <= 0) {
            setRunning(false);
            setColor("#10b981");
            setVisibility("visible");
            setMessage("Stress test terminé !");
        }

        return () => clearInterval(interval);
    }, [running, timeLeft]);

    // Récupération de la fiche
    useEffect(() => {
        startSudoSession();
        invoke<string>("get_pdf_base64")
            .then((dataUri) => {
                setPdfUrl(dataUri);
            })
            .catch(console.error);
    }, []);

    return (
        <main className="container">
            <Feedback
                type={feedbackType}
                visible={visibility === "visible"}
                message={message}
                color={color}
                volume={micVolume}
                onClose={() => {
                    setVisibility("hidden");
                    setFeedbackType(null);
                }}
            />

            <CPUTemperature />
            <section className="ficheContainer">
                <Tabs
                    tabs={[
                        {
                            label: "Fiche PDF",
                            content: <PDFViewer file={PdfUrl} />,
                        },
                        {
                            label: "Terminal",
                            content: (
                                <Terminal
                                    script_output={"Aucun script lancé"}
                                />
                            ),
                        },
                    ]}
                />
            </section>
            <section className="buttons">
                {testScripts.map((cat, idx) => (
                    <div key={cat.category}>
                        <h2>{cat.category}</h2>
                        <div key={idx} className="category">
                            {cat.scripts.map((script, idx) => (
                                <TestButton
                                    disabled={
                                        running && script.name === "stress"
                                    }
                                    key={idx}
                                    color={cat.color}
                                    title={
                                        running && script.name === "stress"
                                            ? `${Math.floor(timeLeft / 60)}:${(
                                                  timeLeft % 60
                                              )
                                                  .toString()
                                                  .padStart(2, "0")}`
                                            : script.name
                                    }
                                    launchScript={
                                        script.name == "stress"
                                            ? startStressTest
                                            : () =>
                                                  rust_script(script.scriptCmd)
                                    }
                                />
                            ))}
                        </div>
                    </div>
                ))}
            </section>
        </main>
    );
}

export default App;
