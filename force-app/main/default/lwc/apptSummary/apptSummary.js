import { LightningElement, api, wire } from 'lwc';
import getAppointmentDetails from '@salesforce/apex/AppointmentController.getAppointmentDetails';

export default class AppointmentSummary extends LightningElement {
    @api recordId;
    reservationDate;
    totalValue;
    totalDuration;
    procedures = [];
    appointmentStatus;

    @wire(getAppointmentDetails, { appointmentId: '$recordId' })
    wiredAppointment({ error, data }) {
        if (data) {
            this.reservationDate = new Date(data.reservationDate).toLocaleDateString();
            this.totalValue = data.totalValue;
            this.totalDuration = data.totalDuration;
            this.procedures = data.procedures;
            this.appointmentStatus = data.appointmentStatus;
        } else if (error) {
            console.error('Error loading appointment details:', error);
        }
        console.log('appointmentId:-------------------', this.recordId); // Verifica si el appointmentId es correcto
    }

    get displaySummaryAppt() {
        return (
            this.appointmentStatus === 'Scheduled' || 
            this.appointmentStatus === 'Pending Payment'
        )
    }
}