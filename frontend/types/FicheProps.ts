export type FicheProps = {
    machine: {
        marque: string,
        model: string,
        numSerie: string;
    },
    cpu: {
        arch: string,
        model: string
    },
    memRam: string,
    disk: {
        type: string,
        marque: string,
        model: string,
        size: string,
        condition: string
    },
    battery: {},
    network: string[],
    gpu : {
        model: string,
        driver: string,
        version: string
    },
    videoInputs: string[]
    screenSize: string
}