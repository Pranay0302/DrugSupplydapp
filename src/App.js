import './styles/App.css'
import React from 'react'
import Card from './components/MintCard'
import BuyCard from './components/BuyCard'
import SellCard from './components/SellCard'
import Particle from './components/Particle'

function App() {
    return (
        <React.Fragment>
            <Particle />
            <div className="App">
                <div className="AppHeader">DRUG SUPPLY CHAIN</div>
                <h5>Power of Decentralization</h5>
                <div className="CardSection">
                    <Card />
                    <BuyCard />
                    <SellCard />
                </div>
            </div>
        </React.Fragment>
    )
}

export default App
