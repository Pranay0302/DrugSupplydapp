import React from 'react'
import { makeStyles } from '@material-ui/core/styles'
import Card from '@material-ui/core/Card'
import CardActions from '@material-ui/core/CardActions'
import CardContent from '@material-ui/core/CardContent'
import Button from '@material-ui/core/Button'
import Typography from '@material-ui/core/Typography'
import TextField from '@material-ui/core/TextField'
import '../../../styles/App.css'

const useStyles = makeStyles({
    root: {
        minWidth: 275,
        padding: '0.4rem',
        boderRadius: '10px',
        margin: '1rem',
        border: 'none',
        outline: 'none',
    },

    title: {
        fontSize: 15,
        margin: 12,
    },
    pos: {
        fontSize: 15,
        margin: 12,
    },
})

export default function OutlinedCard() {
    const classes = useStyles()

    return (
        <Card className={classes.root} variant="outlined">
            <CardContent>
                <Typography
                    className={classes.title}
                    color="textSecondary"
                    gutterBottom
                >
                    Buy Drug
                </Typography>
                <TextField label="UPC" variant="outlined" />
                <Typography className={classes.title} color="textSecondary">
                    Payment Details
                </Typography>
                <Typography className={classes.pos} color="textSecondary">
                    {' '}
                    For further details, <strong>click</strong> on learn more.{' '}
                    <br />
                    You'll be redirected to your{' '}
                    <strong>MetaMask Wallet</strong>
                </Typography>
            </CardContent>
            <CardActions>
                <div>
                    <Button size="small" variant="outlined">
                        Buy
                    </Button>
                </div>
            </CardActions>
        </Card>
    )
}
