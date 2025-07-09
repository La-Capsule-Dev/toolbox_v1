import React, { useState } from "react";

function Tabs({ tabs }) {
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
            <div style={{ marginTop: 16 }}>{tabs[active].content}</div>
        </div>
    );
}

export default Tabs;
