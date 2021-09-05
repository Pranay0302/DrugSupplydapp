import React from 'react'
import { makeStyles } from '@material-ui/core/styles'
import Card from '@material-ui/core/Card'
import CardActions from '@material-ui/core/CardActions'
import CardContent from '@material-ui/core/CardContent'
import Button from '@material-ui/core/Button'
import Typography from '@material-ui/core/Typography'
import TextField from '@material-ui/core/TextField'
import '../styles/App.css'

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
                    Sell Drug
                </Typography>
                <TextField label="UPC" variant="outlined" />
                <Typography className={classes.title} color="textSecondary">
                    Sell
                </Typography>
                <TextField label="Price" variant="outlined" />
            </CardContent>
            <CardActions>
                <div>
                    <Button size="small" variant="outlined">
                        Sell
                    </Button>
                    <Button size="small" variant="outlined">
                        Learn More
                    </Button>
                </div>
            </CardActions>
        </Card>
    )
}
