import React from "react";

export default function PDFViewer({
    file,
    loading,
}: {
    file: string;
    loading: boolean;
}) {
    return (
        <div className="pdfWrapper">
            {loading && <p>Chargement de la fiche</p>}
            <iframe src={file} title="PDF Viewer" />
        </div>
    );
}
