import './styles/App.css'
import React from 'react'
import Card from './components/pages/Cards/MintCard'
import BuyCard from './components/pages/Cards/BuyCard'
import SellCard from './components/pages/Cards/SellCard'
import Particle from './components/Particle'
import { BrowserRouter as Router, Switch, Route, Link } from 'react-router-dom'
import { Button } from '@material-ui/core'
import Learn from './components/pages/Learn/Learn'
import { useState, useEffect } from 'react'
import MLoader from './components/pages/MLoader'

function App() {
    const [load, setLoad] = useState(false)

    useEffect(() => {
        setLoad(true)

        setTimeout(() => {
            setLoad(false)
        }, 6969)
    }, [])

    return (
        <React.Fragment>
            {' '}
            {load ? (
                <MLoader />
            ) : (
                <Router>
                    <Switch>
                        <Route exact path="/">
                            <Particle />
                            <div className="App">
                                <div className="AppHeader">
                                    DRUG SUPPLY CHAIN
                                </div>
                                <h5>Power of Decentralization</h5>
                                <div className="CardSection">
                                    <Card />
                                    <BuyCard />
                                    <SellCard />
                                </div>
                            </div>
                            <Link to="/learn">
                                <div className="learnButton">
                                    <Button variant="outlined">
                                        learn more
                                    </Button>
                                </div>
                            </Link>
                        </Route>
                        <Route exact path="/learn">
                            <Learn />
                        </Route>
                    </Switch>
                </Router>
            )}
        </React.Fragment>
    )
}

export default App
