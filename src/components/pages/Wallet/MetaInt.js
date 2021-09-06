// courtesy: yt (will change the code later)

import { injected } from './Connectors'
import { useWeb3React } from '@web3-react/core'
import '../../../styles/App.css'

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
        <div className="MMbuttonSec">
            <button onClick={connect}>Connect to MetaMask</button>
            {active ? (
                <h6>
                    Connected with <b>{account}</b>
                </h6>
            ) : (
                <h6>Not connected</h6>
            )}
            <button onClick={disconnect}>Disconnect</button>
        </div>
    )
}
