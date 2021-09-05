import { useState } from 'react'
import BarLoader from 'react-spinners/BarLoader'
import '../../styles/App.css'

export default function MLoader() {
    let loading = useState(true)

    return (
        <div className="Spinner">
            <h5>content is loading</h5>
            <BarLoader color="#261C2C" loading={loading} size={130} />
        </div>
    )
}
