import React from "react";

type FeedbackType = "stress" | "micro" | "custom" | "ports" | null;

type Props = {
    type: FeedbackType;
    message?: string;
    color?: string;
    volume?: number;
    onClose: () => void;
    visible: boolean;
    reportLines?: string[];
};

export default function Feedback({
    type,
    message,
    color = "#F97316",
    volume = 0,
    onClose,
    visible,
    reportLines,
}: Props) {
    if (!visible) return null;

    return (
        <div className="overlay">
            <div
                className="popup"
                style={{
                    borderRadius: "1rem",
                    padding: "1.5rem",
                    boxShadow: "0 0 20px rgba(0,0,0,0.3)",
                    width: "min(90%, 400px)",
                    textAlign: "center",
                }}>
                {type === "stress" && (
                    <>
                        <h4 style={{ color }}>{message}</h4>
                        <button onClick={onClose}>Fermer</button>
                    </>
                )}

                {type === "micro" && (
                    <>
                        <h4>Niveau du micro</h4>
                        <div
                            style={{
                                backgroundColor: "#eee",
                                height: "10px",
                                borderRadius: "5px",
                                overflow: "hidden",
                                marginTop: "1rem",
                            }}>
                            <div
                                style={{
                                    width: `${volume}%`,
                                    backgroundColor: "#10b981",
                                    height: "100%",
                                    transition: "width 0.1s ease",
                                }}
                            />
                        </div>
                        <p style={{ marginTop: "0.5rem" }}>{volume} %</p>
                    </>
                )}

                {type === "ports" && (
                    <>
                        <h4>Ports USB :</h4>
                        <div className="wrapper">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Type</th>
                                        <th>Fabricant</th>
                                        <th>Produit</th>
                                        <th>Bus | Port</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {reportLines && reportLines.length > 0 ? (
                                        reportLines.map((line, index) => {
                                            if (
                                                line.includes("===") ||
                                                line.trim() === "" ||
                                                line.includes("Nombre total") ||
                                                line.includes("Répartition") ||
                                                line.includes("Détails")
                                            ) {
                                                return null;
                                            }
                                            if (line.match(/^\d+\./)) {
                                                const parts = line.split(" - ");
                                                if (parts.length >= 2) {
                                                    const deviceInfo = parts[1];
                                                    const busInfo =
                                                        reportLines[index + 1];
                                                    let busPort = "";
                                                    if (
                                                        busInfo &&
                                                        busInfo.includes("Bus:")
                                                    ) {
                                                        const busMatch =
                                                            busInfo.match(
                                                                /Bus: (\d+), Adresse: (\d+), Ports: \[([^\]]+)\]/
                                                            );
                                                        if (busMatch) {
                                                            busPort = `${busMatch[1]} | ${busMatch[3]}`;
                                                        } else {
                                                            busPort = "-";
                                                        }
                                                    }

                                                    return (
                                                        <tr key={index}>
                                                            <td>USB Device</td>
                                                            <td>
                                                                {deviceInfo.split(
                                                                    " "
                                                                )[0] ||
                                                                    "Inconnu"}
                                                            </td>
                                                            <td>
                                                                {deviceInfo
                                                                    .split(" ")
                                                                    .slice(1)
                                                                    .join(
                                                                        " "
                                                                    ) ||
                                                                    "Inconnu"}
                                                            </td>
                                                            <td>{busPort}</td>
                                                        </tr>
                                                    );
                                                }
                                            }

                                            return null;
                                        })
                                    ) : (
                                        <tr>
                                            <td colSpan={4}>
                                                Aucun périphérique USB détecté
                                            </td>
                                        </tr>
                                    )}
                                </tbody>
                            </table>
                        </div>

                        <button onClick={onClose}>Fermer</button>
                    </>
                )}
            </div>
        </div>
    );
}
