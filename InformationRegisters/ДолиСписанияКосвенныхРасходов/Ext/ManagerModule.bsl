﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает соответствие имен ресурсов регистра видам нормируемых расходов.
//
// Возвращаемое значение:
// 	ВидыРасходов - Соотвествие - Результат
// 						* Ключ - Имя ресурса регистра.
// 						* Значение - Имя вида нормируемого расхода.
//
Функция ИменаВидовНормируемыхРасходов() Экспорт
	
	ВидыРасходов = Новый Соответствие; 
	ВидыРасходов.Вставить(
		"ДоляРасходовНаРекламу",
		"РасходыНаРекламуНормируемые");
	ВидыРасходов.Вставить(
		"ДоляПредставительскихРасходов",
		"ПредставительскиеРасходы");
	ВидыРасходов.Вставить(
		"ДоляРасходовНаДобровольноеМедицинскоеСтрахование",
		"ДобровольноеЛичноеСтрахование");
	ВидыРасходов.Вставить(
		"ДоляРасходовНаДобровольноеСтрахованиеЖизни",
		"ДобровольноеСтрахованиеПоДоговорамДолгосрочногоСтрахованияЖизниРаботников");
	ВидыРасходов.Вставить(
		"ДоляРасходовНаДобровольноеСтрахованиеОтНесчастныхСлучаев",
		"ДобровольноеЛичноеСтрахованиеНаСлучайСмертиИлиУтратыРаботоспособности");
	ВидыРасходов.Вставить(
		"ДоляРасходовНаВозмещениеПроцентовРаботникам",
		"РасходыНаВозмещениеЗатратРаботниковПоУплатеПроцентов");
		
	Возврат ВидыРасходов;
		
КонецФункции

#КонецОбласти

#КонецЕсли
