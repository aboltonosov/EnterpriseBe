﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность" (клиент, повт. исп.).
// Обслуживает подключаемые команды.
// Выполняется на клиенте, возвращаемые значения кэшируются на время сеанса.
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Возвращает описание команды по имени элемента формы.
Функция ОписаниеКоманды(ИмяКоманды, АдресНастроек) Экспорт
	Возврат ПодключаемыеКомандыВызовСервера.ОписаниеКоманды(ИмяКоманды, АдресНастроек);
КонецФункции

#КонецОбласти
