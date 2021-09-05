import './styles/App.css'
import React from 'react'
import Card from './components/MintCard'
import BuyCard from './components/BuyCard'
import SellCard from './components/SellCard'
import Particle from './components/Particle'
import { BrowserRouter as Router, Switch, Route, Link } from 'react-router-dom'
import { Button } from '@material-ui/core'
import Learn from './components/Learn/Learn'

function App() {
    return (
        <React.Fragment>
            <Router>
                <Switch>
                    <Route exact path="/">
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
                        <Link to="/learn">
                            <div className="learnButton">
                                <Button variant="outlined">learn more</Button>
                            </div>
                        </Link>
                    </Route>
                    <Route exact path="/learn">
                        <Learn />
                    </Route>
                </Switch>
            </Router>
        </React.Fragment>
    )
}

export default App
