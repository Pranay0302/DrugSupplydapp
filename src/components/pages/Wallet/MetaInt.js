// courtesy: yt (will change the code later)

import { injected } from './Connectors'
import { useWeb3React } from '@web3-react/core'

export default function MetaInt() {
    const { active, account, activate, deactivate } = useWeb3React()

    async function connect() {
        try {
            await activate(injected)
        } catch (ex) {
            console.log(ex)
        }
    }

    async function disconnect() {
        try {
            deactivate()
        } catch (ex) {
            console.log(ex)
        }
    }

    return (
        <div className="flex flex-col items-center justify-center">
            <button onClick={connect}>Connect to MetaMask</button>
            {active ? (
                <span>
                    Connected with <b>{account}</b>
                </span>
            ) : (
                <span>Not connected</span>
            )}
            <button onClick={disconnect}>Disconnect</button>
        </div>
    )
}
