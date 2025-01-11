import { createElement } from '@lwc/test-utils';
import AppointmentSummary from 'c/appointmentSummary';
import getAppointmentDetails from '@salesforce/apex/AppointmentController.getAppointmentDetails';

// Mocks de Apex
jest.mock('@salesforce/apex/AppointmentController.getAppointmentDetails', () => ({
    default: jest.fn()
}));

describe('c-appointment-summary', () => {
    afterEach(() => {
        // Limpia el DOM después de cada prueba
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('renders appointment details correctly when data is received', async () => {
        // Datos de prueba
        const mockData = {
            reservationDate: '2025-01-11T10:00:00.000Z',
            totalValue: 200,
            totalDuration: '1 hour',
            procedures: [
                { name: 'Procedure 1', value: 100, professionalName: 'Dr. Smith' },
                { name: 'Procedure 2', value: 100, professionalName: 'Dr. Brown' }
            ],
            appointmentStatus: 'Completed'
        };

        // Simulamos la respuesta de Apex
        getAppointmentDetails.mockResolvedValue(mockData);

        // Creamos el elemento
        const element = createElement('c-appointment-summary', {
            is: AppointmentSummary
        });

        // Establecemos el recordId
        element.recordId = '12345';
        document.body.appendChild(element);

        // Esperamos que la llamada a la wire se complete
        await flushPromises();

        // Verifica que los datos se rendericen correctamente
        const summaryTitle = element.shadowRoot.querySelector('.summary-title');
        expect(summaryTitle.textContent).toBe('Resumen de la Cita');

        const dateParagraph = element.shadowRoot.querySelector('p');
        expect(dateParagraph.textContent).toBe('Fecha de la cita: 01/11/2025');

        const rows = element.shadowRoot.querySelectorAll('.procedures-table tbody tr');
        expect(rows.length).toBe(2);

        const totalValueParagraph = element.shadowRoot.querySelector('.summary-totals p:nth-child(1)');
        expect(totalValueParagraph.textContent).toBe('Valor Total: 200');

        const totalDurationParagraph = element.shadowRoot.querySelector('.summary-totals p:nth-child(2)');
        expect(totalDurationParagraph.textContent).toBe('Duración Total: 1 hour');
    });

    it('does not render the summary when appointmentStatus is not "Completed" or "Pending Payment"', async () => {
        // Datos de prueba con estado diferente
        const mockData = {
            reservationDate: '2025-01-11T10:00:00.000Z',
            totalValue: 200,
            totalDuration: '1 hour',
            procedures: [],
            appointmentStatus: 'Scheduled'
        };

        // Simulamos la respuesta de Apex
        getAppointmentDetails.mockResolvedValue(mockData);

        // Creamos el elemento
        const element = createElement('c-appointment-summary', {
            is: AppointmentSummary
        });

        element.recordId = '12345';
        document.body.appendChild(element);

        // Esperamos que la llamada a la wire se complete
        await flushPromises();

        // Verifica que el componente no se muestra
        const summaryDiv = element.shadowRoot.querySelector('.appointment-summary');
        expect(summaryDiv).toBeNull();  // No debe renderizarse si el estado no es "Completed" o "Pending Payment"
    });

    it('displays the summary when appointmentStatus is "Completed" or "Pending Payment"', async () => {
        // Datos de prueba con estado "Completed"
        const mockData = {
            reservationDate: '2025-01-11T10:00:00.000Z',
            totalValue: 200,
            totalDuration: '1 hour',
            procedures: [],
            appointmentStatus: 'Completed'
        };

        // Simulamos la respuesta de Apex
        getAppointmentDetails.mockResolvedValue(mockData);

        // Creamos el elemento
        const element = createElement('c-appointment-summary', {
            is: AppointmentSummary
        });

        element.recordId = '12345';
        document.body.appendChild(element);

        // Esperamos que la llamada a la wire se complete
        await flushPromises();

        // Verifica que el resumen se renderiza correctamente
        const summaryDiv = element.shadowRoot.querySelector('.appointment-summary');
        expect(summaryDiv).not.toBeNull();  // Debe renderizarse si el estado es "Completed"
    });
});
