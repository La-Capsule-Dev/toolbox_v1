import { useState } from "react";

type TabsProps = { tabs: { label: string; content: any }[] };

function Tabs({ tabs }: TabsProps) {
    const [active, setActive] = useState(0);
    return (
        <div>
            <div style={{ display: "flex" }}>
                {tabs.map((tab, idx) => (
                    <button
                        key={tab.label}
                        onClick={() => setActive(idx)}
                        className={active === idx ? "active" : ""}>
                        {tab.label}
                    </button>
                ))}
            </div>
            <div style={{ marginTop: 15 }}>{tabs[active].content}</div>
        </div>
    );
}

export default Tabs;
