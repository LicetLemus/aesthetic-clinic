import { LightningElement } from 'lwc';

export default class ApptSummary extends LightningElement {
    SchedulingDate = '2021-07-01';
    Procedures = [
        {
            id: '1',
            name : 'Limpieza Dental',
            CostOfEachProcedure: 'Limpieza Dental',
            professional: 'Dr. Juan Pérez',
        },
        {
            id: '2',
            name: 'Ortodoncia',
            CostOfEachProcedure: 'Dra. María López',
            professional: 'Dra. María López',
        }
    ]
    totalValue = 12000;
    totalDuration = 120;
}