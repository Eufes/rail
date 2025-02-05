﻿
#Область РаботаСИсходящимиСообщениями //*******************************************

Функция ОпределитьТипИсходящегоСообщения(МнемокодСообщения) Экспорт

	//Запрос=
	
КонецФункции

Функция ВнешняяСистемаПоТипуИсходящегоСообщения(ТипИсходящегоСообщения) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТипИсходящегоСообщения.Владелец КАК ВнешняяСистема
	|ИЗ
	|	Справочник.EUF_ПроводникТипИсходящегоСообщения КАК ТипИсходящегоСообщения
	|ГДЕ
	|	ТипИсходящегоСообщения.Ссылка = &ТипИсходящегоСообщения";
	Запрос.УстановитьПараметр("ТипИсходящегоСообщения", ТипИсходящегоСообщения);
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.ВнешняяСистема;				
	Иначе
		Возврат Неопределено;
	КонецЕсли;	
	
КонецФункции

#КонецОбласти // РаботаСИсходящимиСообщениями

#Область РаботаСВходящимиСообщениями //*******************************************

Функция ОпределитьТипВходящегоСообщения(МнемокодСообщения, ВнешняяСистема) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	EUF_ПроводникТипВходящегоСообщения.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.EUF_ПроводникТипВходящегоСообщения КАК EUF_ПроводникТипВходящегоСообщения
	|ГДЕ
	|	EUF_ПроводникТипВходящегоСообщения.ТехническоеИмя = &ТехническоеИмя
	|	И EUF_ПроводникТипВходящегоСообщения.Владелец = &ВнешняяСистема";
	Запрос.УстановитьПараметр("ВнешняяСистема", ВнешняяСистема);
	Запрос.УстановитьПараметр("ТехническоеИмя", МнемокодСообщения);
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе	
		Возврат Неопределено;		
	КонецЕсли;
	
КонецФункции

Функция ВнешняяСистемаПоТипуВходящегоСообщения(ТипВходящегоСообщения) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТипВходящегоСообщения.Владелец КАК ВнешняяСистема
	|ИЗ
	|	Справочник.EUF_ПроводникТипВходящегоСообщения КАК ТипВходящегоСообщения
	|ГДЕ
	|	ТипВходящегоСообщения.Ссылка = &ТипВходящегоСообщения";
	Запрос.УстановитьПараметр("ТипВходящегоСообщения", ТипВходящегоСообщения);
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.ВнешняяСистема;				
	Иначе
		Возврат Неопределено;
	КонецЕсли;	
	
КонецФункции

Функция СверитьПользователяВнешнейСистемы(ВнешняяСистема, ТекущийПользователь) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	EUF_ПроводникВнешниеСистемы.ПользовательСоединения КАК ПользовательСоединения
	|ИЗ
	|	ПланОбмена.EUF_ПроводникВнешниеСистемы КАК EUF_ПроводникВнешниеСистемы
	|ГДЕ
	|	EUF_ПроводникВнешниеСистемы.Ссылка = &ВнешняяСистема";
	Запрос.УстановитьПараметр("ВнешняяСистема", ВнешняяСистема);
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Если ЗначениеЗаполнено(Выборка.ПользовательСоединения) Тогда
			Возврат Выборка.ПользовательСоединения = ТекущийПользователь;
		Иначе
			Возврат Истина;
		КонецЕсли;	
	Иначе
		Возврат Ложь;
	КонецЕсли;		
	
КонецФункции	

#КонецОбласти // РаботаСВходящимиСообщениями
