#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПриКопировании(ОбъектКопирования)
	ТехническоеИмя = "";
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;	
	
	Если Не ДополнительныеСвойства.Свойство("ПроверкаВыполнена") Тогда
		ТекстСообщения = Справочники.MultiPort_ТипИсходящегоСообщения.ИдентификаторТипаИсходящегоУникален(ЭтотОбъект, Отказ);
		Если Отказ Тогда			
			MultiPort_ШлюзБСПКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Возврат;
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры  

#КонецЕсли