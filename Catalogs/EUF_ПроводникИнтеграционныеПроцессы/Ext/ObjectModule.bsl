﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ДополнительныеСвойства.Свойство("ПроверкаВыполнена") Тогда
		ТекстСообщения = Справочники.EUF_ПроводникИнтеграционныеПроцессы.ИдентификаторПроцессаУникален(ЭтотОбъект, Отказ);
		Если Отказ Тогда			
			EUF_ПроводникШлюзБСПКлиентСервер.СообщитьПользователю(ТекстСообщения, , , , Отказ);
			Возврат;
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли