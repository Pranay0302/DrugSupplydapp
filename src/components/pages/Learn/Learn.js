import React from 'react'
import { makeStyles } from '@material-ui/core/styles'
import '../../../styles/App.css'
import Accordion from '@material-ui/core/Accordion'
import AccordionSummary from '@material-ui/core/AccordionSummary'
import AccordionDetails from '@material-ui/core/AccordionDetails'
import Typography from '@material-ui/core/Typography'
import ExpandMoreIcon from '@material-ui/icons/ExpandMore'
import { Link } from 'react-router-dom'
import { Button } from '@material-ui/core'

const useStyles = makeStyles((theme) => ({
    root: {
        width: '100%',
        textAlign: 'center',
        minHeight: '100vh',
        display: 'flex',
        flexDirection: 'column',
        justifyContent: 'center',
    },
    heading: {
        fontSize: theme.typography.pxToRem(15),
        fontWeight: theme.typography.fontWeightRegular,
    },
    acc: {
        backgroundColor: '#5C527F',
        color: '#ffffff',
    },
}))

export default function Learn() {
    const classes = useStyles()

    return (
        <React.Fragment>
            <div className={classes.root}>
                <Accordion className={classes.acc}>
                    <AccordionSummary
                        expandIcon={<ExpandMoreIcon />}
                        aria-controls="panel1a-content"
                        id="panel1a-header"
                    >
                        <Typography className={classes.heading}>
                            What is Minting?
                        </Typography>
                    </AccordionSummary>
                    <AccordionDetails>
                        <Typography>
                            Minting or producing a drug deals with the approval
                            of CDER; Once the drug is approved and accepted, The
                            user can mint the drug. The supply chain is tracked
                            efficiently using this blockchain technology. Enter
                            the UPC (Universal Product Code) of the drug and{' '}
                            <strong>click</strong> on <em>commence</em>
                        </Typography>
                    </AccordionDetails>
                </Accordion>
                <Accordion className={classes.acc}>
                    <AccordionSummary
                        expandIcon={<ExpandMoreIcon />}
                        aria-controls="panel2a-content"
                        id="panel2a-header"
                    >
                        <Typography className={classes.heading}>
                            How will you buy?
                        </Typography>
                    </AccordionSummary>
                    <AccordionDetails>
                        <Typography>
                            The User can buy the drug if he/she has the UPC code
                            of the product, The user can click on the{' '}
                            <em>pay</em> for further proceedings
                        </Typography>
                    </AccordionDetails>
                </Accordion>
                <Accordion className={classes.acc}>
                    <AccordionSummary
                        expandIcon={<ExpandMoreIcon />}
                        aria-controls="panel2a-content"
                        id="panel2a-header"
                    >
                        <Typography className={classes.heading}>
                            How will you Sell?
                        </Typography>
                    </AccordionSummary>
                    <AccordionDetails>
                        <Typography>
                            The User can sell the drug if he/she has the UPC
                            code of the product and with the amount. The user
                            can click on the <em>sell</em> the product.
                        </Typography>
                    </AccordionDetails>
                </Accordion>
                <Link to="/">
                    <Button className="homeButton" variant="outlined">
                        home
                    </Button>
                </Link>
            </div>
        </React.Fragment>
    )
}
