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
        console.log('appointmentId:', this.recordId); // Verify the appointmentId is correct
    }

    get displaySummaryAppt() {
        return (
            this.appointmentStatus === 'Completed' || 
            this.appointmentStatus === 'Pending Payment'
        )
    }
}