﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция ЕстьЗапись(ПериодЗаписи, ТипЗаписи, Ключ, ОперацияСтатистики)
    
    Запрос = Новый Запрос;
    
    Запрос.Текст = "
    |ВЫБРАТЬ ПЕРВЫЕ 1
    |   ИСТИНА
    |ИЗ
    |   РегистрСведений.ЗамерыСтатистики
    |ГДЕ
    |   ПериодЗаписи = &ПериодЗаписи
    |   И ТипЗаписи = &ТипЗаписи
    |   И Ключ = &Ключ
    |   И ОперацияСтатистики = &ОперацияСтатистики
    |";
    
    Запрос.УстановитьПараметр("ПериодЗаписи", ПериодЗаписи);
    Запрос.УстановитьПараметр("ТипЗаписи", ТипЗаписи);
    Запрос.УстановитьПараметр("Ключ", Ключ);
    Запрос.УстановитьПараметр("ОперацияСтатистики", ОперацияСтатистики);
    
    
    УстановитьПривилегированныйРежим(Истина);
    Результат = Запрос.Выполнить();
    УстановитьПривилегированныйРежим(Ложь);
    
    Возврат НЕ Результат.Пустой();    
    
КонецФункции

Процедура ЗаписатьОперациюБизнесСтатистики(ПериодЗаписи, ТипЗаписи, Ключ, ОперацияСтатистики, ЗначениеОперации, Замещать) Экспорт
    
    ЕстьЗапись = ЕстьЗапись(ПериодЗаписи, ТипЗаписи, Ключ, ОперацияСтатистики);
    
    Если НЕ ЕстьЗапись ИЛИ Замещать Тогда
        
        НачатьТранзакцию();
        Попытка
            
            Блокировка = Новый БлокировкаДанных;
            
            ЭлементБлокировкиПериодЗаписи = Блокировка.Добавить("РегистрСведений.ЗамерыСтатистики");
		    ЭлементБлокировкиПериодЗаписи.УстановитьЗначение("ПериодЗаписи", ПериодЗаписи);
            
            ЭлементБлокировкиПериодЗаписи = Блокировка.Добавить("РегистрСведений.ЗамерыСтатистики");
		    ЭлементБлокировкиПериодЗаписи.УстановитьЗначение("ТипЗаписи", ТипЗаписи);
            
            ЭлементБлокировкиПериодЗаписи = Блокировка.Добавить("РегистрСведений.ЗамерыСтатистики");
		    ЭлементБлокировкиПериодЗаписи.УстановитьЗначение("Ключ", Ключ);
            
            ЭлементБлокировкиПериодЗаписи = Блокировка.Добавить("РегистрСведений.ЗамерыСтатистики");
		    ЭлементБлокировкиПериодЗаписи.УстановитьЗначение("ОперацияСтатистики", ОперацияСтатистики);
                           
		    Блокировка.Заблокировать();
            
            ЕстьЗапись = ЕстьЗапись(ПериодЗаписи, ТипЗаписи, Ключ, ОперацияСтатистики);
            
            Если НЕ ЕстьЗапись ИЛИ Замещать Тогда
                
                МенеджерЗаписи = СоздатьМенеджерЗаписи();
                МенеджерЗаписи.ПериодЗаписи = ПериодЗаписи;
                МенеджерЗаписи.Ключ = Ключ;
                МенеджерЗаписи.ТипЗаписи = ТипЗаписи;
                МенеджерЗаписи.ОперацияСтатистики = ОперацияСтатистики;
                МенеджерЗаписи.ИдентификаторУдаления = НачалоДня(ПериодЗаписи);
                МенеджерЗаписи.ЗначениеОперации = ЗначениеОперации;
                
                УстановитьПривилегированныйРежим(Истина);
                Если ЕстьЗапись И Замещать Тогда
                    МенеджерЗаписи.Записать(Истина);
                Иначе
                    МенеджерЗаписи.Записать(Ложь);
                КонецЕсли;
                УстановитьПривилегированныйРежим(Ложь);
                
            КонецЕсли;
            ЗафиксироватьТранзакцию();
        Исключение
            ОтменитьТранзакцию();
			ОП = ОписаниеОшибки();
        КонецПопытки;
        
    КонецЕсли;
         
КонецПроцедуры

Функция ПолучитьЗамерыЧаса(ДатаНачала, ДатаОкончания) Экспорт
    
    Возврат ПолучитьЗамерыПоТипу(ДатаНачала, ДатаОкончания, 1);
        
КонецФункции

Функция ПолучитьЗамерыСутки(ДатаНачала, ДатаОкончания) Экспорт
    
    Возврат ПолучитьЗамерыПоТипу(ДатаНачала, ДатаОкончания, 2);
        
КонецФункции

Функция ПолучитьЗамерыПоТипу(ДатаНачала, ДатаОкончания, ТипЗаписи)
    
    Запрос = Новый Запрос;
    Запрос.Текст = "
    |ВЫБРАТЬ
    |   ОперацииСтатистики.Наименование КАК ОперацияСтатистики,
    |   ЗамерыОперацииСтатистики.ПериодЗаписи КАК Период,
    |   КОЛИЧЕСТВО(*) КАК КоличествоЗначений,
    |   СУММА(ЗамерыОперацииСтатистики.ЗначениеОперации) КАК СуммаЗначений
    |ИЗ
    |   РегистрСведений.ЗамерыСтатистики КАК ЗамерыОперацииСтатистики
    |ВНУТРЕННЕЕ СОЕДИНЕНИЕ
    |   РегистрСведений.ОперацииСтатистики КАК ОперацииСтатистики
	|ПО
	|	ЗамерыОперацииСтатистики.ОперацияСтатистики = ОперацииСтатистики.ИдентификаторОперации
    |ГДЕ
    |   ЗамерыОперацииСтатистики.ТипЗаписи = &ТипЗаписи
    |   И ЗамерыОперацииСтатистики.ПериодЗаписи МЕЖДУ &ДатаНачала И &ДатаОкончания
    |СГРУППИРОВАТЬ ПО
    |   ОперацииСтатистики.Наименование,
    |   ЗамерыОперацииСтатистики.ПериодЗаписи
    |";
    
    Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
    // SDF - Не забыть убрать 86400
    Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания  + 86400);
    Запрос.УстановитьПараметр("ТипЗаписи", ТипЗаписи);
    
    Результат = Запрос.Выполнить();
    
    Возврат Результат;
    
КонецФункции

#КонецОбласти

#КонецЕсли
