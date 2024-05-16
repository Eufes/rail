﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция ИдентификаторПроцессаУникален(Объект, Отказ) Экспорт
	
	ТекстСообщения = "";
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИнтеграционныеПроцессы.Представление КАК Представление,
	|	ИнтеграционныеПроцессы.Код КАК Код
	|ИЗ
	|	Справочник.EUF_ПроводникИнтеграционныеПроцессы КАК ИнтеграционныеПроцессы
	|ГДЕ
	|	ИнтеграционныеПроцессы.ИдентификаторПроцесса = &ИдентификаторПроцесса
	|	И ИнтеграционныеПроцессы.Ссылка <> &Ссылка";
	Запрос.УстановитьПараметр("ИдентификаторПроцесса", Объект.ИдентификаторПроцесса);
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	Если Выборка.Следующий() Тогда
		ТекстСообщения = СтрШаблон("Процесс с таким идентификатором уже существует %1 %2",
									Выборка.Код, Выборка.Представление);		
		Возврат ТекстСообщения;		
	КонецЕсли;
	
	Возврат ТекстСообщения;
	
КонецФункции	

// Возвращает ссылку на интеграционный процесс по идентификатору
//
// Параметры:
//  ИдентификаторПодключения - Строка - идентификатор подключения
// 
// Возвращаемое значение:
//  СправочникСсылка.EUF_ПроводникИнтеграционныеПроцессы, Неопределено - ссылка на элемент, если найден.
//
Функция ПолучитьПроцессПоИдентификатору(ИдентификаторПроцесса) Экспорт
	
	Если Не ЗначениеЗаполнено(ИдентификаторПроцесса) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ТипЗнч(ИдентификаторПроцесса) <> Тип("Строка") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ИнтеграционныеПроцессы.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.EUF_ПроводникИнтеграционныеПроцессы КАК ИнтеграционныеПроцессы
	|ГДЕ
	|	ИнтеграционныеПроцессы.ИдентификаторПроцесса = &ИдентификаторПроцесса";
	Запрос.УстановитьПараметр("ИдентификаторПроцесса", ИдентификаторПроцесса);
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

#КонецЕсли